/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dom/flutter_dom.dart';
import 'package:flutter_dom/gesture.dart';
import 'package:flutter_dom/css.dart';
import 'package:flutter_dom/src/dom/element_registry.dart';

class FlutterDom extends StatefulWidget {
  // The background color for viewport, default to transparent.
  final Color? background;

  // the width of flutterDomWidget
  final double? viewportWidth;

  // the height of flutterDomWidget
  final double? viewportHeight;

  //  The initial bundle to load.
  final FlutterDomBundle? bundle;

  // The animationController of Flutter Route object.
  // Pass this object to flutterDomWidget to make sure flutterDom execute JavaScripts scripts after route transition animation completed.
  final AnimationController? animationController;

  // The methods of the flutterDomNavigateDelegation help you implement custom behaviors that are triggered
  // during a flutterDom view's process of loading, and completing a navigation request.
  final FlutterDomNavigationDelegate? navigationDelegate;

  // A method channel for receiving messaged from JavaScript code and sending message to JavaScript.
  final FlutterDomMethodChannel? javaScriptChannel;

  // Register the RouteObserver to observer page navigation.
  // This is useful if you wants to pause flutterDom timers and callbacks when flutterDom widget are hidden by page route.
  // https://api.flutter.dev/flutter/widgets/RouteObserver-class.html
  final RouteObserver<ModalRoute<void>>? routeObserver;

  // Trigger when flutterDom controller once created.
  final OnControllerCreated? onControllerCreated;

  final LoadErrorHandler? onLoadError;

  final LoadHandler? onLoad;

  final JSErrorHandler? onJSError;

  // Open a service to support Chrome DevTools for debugging.
  final DevToolsService? devToolsService;

  final GestureListener? gestureListener;

  final HttpClientInterceptor? httpClientInterceptor;

  final UriParser? uriParser;

  FlutterDomController? get controller {
    return FlutterDomController.getControllerOfName(shortHash(this));
  }

  // Set flutterDom http cache mode.
  static void setHttpCacheMode(HttpCacheMode mode) {
    HttpCacheController.mode = mode;
    if (kDebugMode) {
      print('FlutterDom http cache mode set to $mode.');
    }
  }

  static bool _isValidCustomElementName(localName) {
    return RegExp(r'^[a-z][.0-9_a-z]*-[\-.0-9_a-z]*$').hasMatch(localName);
  }

  static void defineCustomElement(String tagName, ElementCreator creator) {
    if (!_isValidCustomElementName(tagName)) {
      throw ArgumentError('The element name "$tagName" is not valid.');
    }
    defineElement(tagName.toUpperCase(), creator);
  }

  Future<void> load(FlutterDomBundle bundle) async {
    await controller?.load(bundle);
  }

  Future<void> reload() async {
    await controller?.reload();
  }

  FlutterDom(
      {Key? key,
      this.viewportWidth,
      this.viewportHeight,
      this.bundle,
      this.onControllerCreated,
      this.onLoad,
      this.navigationDelegate,
      this.javaScriptChannel,
      this.background,
      this.gestureListener,
      this.devToolsService,
      // flutterDom's http client interceptor.
      this.httpClientInterceptor,
      this.uriParser,
      this.routeObserver,
      // flutterDom's viewportWidth options only works fine when viewportWidth is equal to window.physicalSize.width / window.devicePixelRatio.
      // Maybe got unexpected error when change to other values, use this at your own risk!
      // We will fixed this on next version released. (v0.6.0)
      // Disable viewportWidth check and no assertion error report.
      bool disableViewportWidthAssertion = false,
      // flutterDom's viewportHeight options only works fine when viewportHeight is equal to window.physicalSize.height / window.devicePixelRatio.
      // Maybe got unexpected error when change to other values, use this at your own risk!
      // We will fixed this on next version release. (v0.6.0)
      // Disable viewportHeight check and no assertion error report.
      bool disableViewportHeightAssertion = false,
      // Callback functions when loading Javascript scripts failed.
      this.onLoadError,
      this.animationController,
      this.onJSError})
      : super(key: key);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<double>('viewportWidth', viewportWidth));
    properties
        .add(DiagnosticsProperty<double>('viewportHeight', viewportHeight));
  }

  @override
  _FlutterDomState createState() => _FlutterDomState();
}

class _FlutterDomState extends State<FlutterDom> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return FlutterDomTextControl(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.routeObserver != null) {
      widget.routeObserver!.subscribe(this, ModalRoute.of(context)!);
    }
  }

  // Resume call timer and callbacks when flutterDom widget change to visible.
  @override
  void didPopNext() {
    assert(widget.controller != null);
    widget.controller!.resume();
  }

  // Pause all timer and callbacks when flutterDom widget has been invisible.
  @override
  void didPushNext() {
    assert(widget.controller != null);
    widget.controller!.pause();
  }

  @override
  void dispose() {
    if (widget.routeObserver != null) {
      widget.routeObserver!.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void deactivate() {
    // Deactivate all WidgetElements in flutterDom when flutterDom Widget is deactivated.
    widget.controller!.view.deactivateWidgetElements();

    super.deactivate();
  }
}

class FlutterDomRenderObjectWidget extends SingleChildRenderObjectWidget {
  // Creates a widget that visually hides its child.
  const FlutterDomRenderObjectWidget(
      FlutterDom widget, WidgetDelegate widgetDelegate,
      {Key? key})
      : _flutterDomWidget = widget,
        _widgetDelegate = widgetDelegate,
        super(key: key);

  final FlutterDom _flutterDomWidget;
  final WidgetDelegate _widgetDelegate;

  @override
  RenderObject createRenderObject(BuildContext context) {
    if (kProfileMode) {
      PerformanceTiming.instance().mark(PERF_CONTROLLER_INIT_START);
    }

    double viewportWidth = _flutterDomWidget.viewportWidth ??
        window.physicalSize.width / window.devicePixelRatio;
    double viewportHeight = _flutterDomWidget.viewportHeight ??
        window.physicalSize.height / window.devicePixelRatio;

    if (viewportWidth == 0.0 && viewportHeight == 0.0) {
      throw FlutterError(
          '''Can't get viewportSize from window. Please set viewportWidth and viewportHeight manually.
This situation often happened when you trying creating flutterDom when FlutterView not initialized.''');
    }

    FlutterDomController controller = FlutterDomController(
      shortHash(_flutterDomWidget.hashCode), viewportWidth, viewportHeight,
      background: _flutterDomWidget.background,
      showPerformanceOverlay:
          Platform.environment[ENABLE_PERFORMANCE_OVERLAY] != null,
      entrypoint: _flutterDomWidget.bundle,
      // Execute entrypoint when mount manually.
      autoExecuteEntrypoint: false,
      onLoad: _flutterDomWidget.onLoad,
      onLoadError: _flutterDomWidget.onLoadError,
      onJSError: _flutterDomWidget.onJSError,
      methodChannel: _flutterDomWidget.javaScriptChannel,
      gestureListener: _flutterDomWidget.gestureListener,
      navigationDelegate: _flutterDomWidget.navigationDelegate,
      devToolsService: _flutterDomWidget.devToolsService,
      httpClientInterceptor: _flutterDomWidget.httpClientInterceptor,
      widgetDelegate: _widgetDelegate,
      uriParser: _flutterDomWidget.uriParser,
    );

    controller.waitUntilInited.then((value) {
      OnControllerCreated? onControllerCreated =
          _flutterDomWidget.onControllerCreated;
      if (onControllerCreated != null) {
        onControllerCreated(controller);
      }
      if (kProfileMode) {
        PerformanceTiming.instance().mark(PERF_CONTROLLER_INIT_END);
      }
    });
    return controller.view.getRootRenderObject();
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
    FlutterDomController controller =
        (renderObject as RenderObjectWithControllerMixin).controller!;
    controller.name = shortHash(_flutterDomWidget.hashCode);

    bool viewportWidthHasChanged =
        controller.view.viewportWidth != _flutterDomWidget.viewportWidth;
    bool viewportHeightHasChanged =
        controller.view.viewportHeight != _flutterDomWidget.viewportHeight;

    double viewportWidth = _flutterDomWidget.viewportWidth ??
        window.physicalSize.width / window.devicePixelRatio;
    double viewportHeight = _flutterDomWidget.viewportHeight ??
        window.physicalSize.height / window.devicePixelRatio;

    if (controller.view.document.documentElement == null) return;

    if (viewportWidthHasChanged) {
      controller.view.viewportWidth = viewportWidth;
      controller.view.document.documentElement!.renderStyle.width =
          CSSLengthValue(viewportWidth, CSSLengthType.PX);
    }

    if (viewportHeightHasChanged) {
      controller.view.viewportHeight = viewportHeight;
      controller.view.document.documentElement!.renderStyle.height =
          CSSLengthValue(viewportHeight, CSSLengthType.PX);
    }
  }

  @override
  void didUnmountRenderObject(covariant RenderObject renderObject) {
    FlutterDomController controller =
        (renderObject as RenderObjectWithControllerMixin).controller!;
    controller.dispose();
  }

  @override
  _FlutterDomRenderObjectElement createElement() {
    return _FlutterDomRenderObjectElement(this);
  }
}

class _FlutterDomRenderObjectElement extends SingleChildRenderObjectElement {
  _FlutterDomRenderObjectElement(FlutterDomRenderObjectWidget widget)
      : super(widget);

  @override
  void mount(Element? parent, Object? newSlot) async {
    super.mount(parent, newSlot);

    FlutterDomController controller =
        (renderObject as RenderObjectWithControllerMixin).controller!;

    // We should make sure every flutter elements created under flutterDom can be walk up to the root.
    // So we bind _FlutterDomRenderObjectElement into FlutterDomController, and widgetElements created by controller can follow this to the root.
    controller.rootFlutterElement = this;
    await controller.waitUntilInited;
    await controller.executeEntrypoint(
        animationController: widget._flutterDomWidget.animationController);
  }

  // RenderObjects created by flutterDom are manager by flutterDom itself. There are no needs to operate renderObjects on _FlutterDomRenderObjectElement.
  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {}
  @override
  void moveRenderObjectChild(
      RenderObject child, Object? oldSlot, Object? newSlot) {}
  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {}

  @override
  FlutterDomRenderObjectWidget get widget =>
      super.widget as FlutterDomRenderObjectWidget;
}
