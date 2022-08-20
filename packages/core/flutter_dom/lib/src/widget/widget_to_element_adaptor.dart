/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dom/webf.dart';
import 'package:flutter_dom/dom.dart' as dom;

class WebFRenderObjectToWidgetAdapter<T extends RenderObject> extends RenderObjectWidget {
  /// Creates a bridge from a [RenderObject] to an [Element] tree.
  ///
  /// Used by [WidgetsBinding] to attach the root widget to the [RenderView].
  WebFRenderObjectToWidgetAdapter({
    this.child,
    required this.container,
    this.debugShortDescription,
  }) : super(key: GlobalObjectKey(container));

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// The [RenderObject] that is the parent of the [Element] created by this widget.
  final ContainerRenderObjectMixin<RenderBox, ContainerBoxParentData<RenderBox>> container;

  /// A short description of this widget used by debugging aids.
  final String? debugShortDescription;

  @override
  WebFRenderObjectToWidgetElement<T> createElement() => WebFRenderObjectToWidgetElement<T>(this);

  @override
  ContainerRenderObjectMixin<RenderBox, ContainerBoxParentData<RenderBox>> createRenderObject(BuildContext context) =>
      container;

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {}

  /// Inflate this widget and actually set the resulting [RenderObject] as the
  /// child of [container].
  WebFRenderObjectToWidgetElement<T> attachToRenderTree(
      BuildOwner owner, RenderObjectElement parentElement, bool needBuild) {
    Element? element;

    owner.lockState(() {
      element = createElement();
      assert(element != null);
    });

    // If renderview is building,skip the buildScope phase.
    if (!needBuild) {
      if (element != null) {
        element?.mount(parentElement, null);
      }
    } else {
      owner.buildScope(element!, () {
        if (element != null) {
          element?.mount(parentElement, null);
        }
      });
    }

    return element! as WebFRenderObjectToWidgetElement<T>;
  }

  @override
  String toStringShort() => debugShortDescription ?? super.toStringShort();
}

class WebFRenderObjectToWidgetElement<T extends RenderObject> extends RenderObjectElement {
  /// Creates an element that is hosted by a [RenderObject].
  ///
  /// The [RenderObject] created by this element is not automatically set as a
  /// child of the hosting [RenderObject]. To actually attach this element to
  /// the render tree, call [RenderObjectToWidgetAdapter.attachToRenderTree].
  WebFRenderObjectToWidgetElement(WebFRenderObjectToWidgetAdapter<T> widget) : super(widget);

  @override
  WebFRenderObjectToWidgetAdapter get widget => super.widget as WebFRenderObjectToWidgetAdapter<T>;

  Element? _child;

  static const Object _rootChildSlot = Object();

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_child != null) visitor(_child!);
  }

  @override
  void forgetChild(Element child) {
    assert(child == _child);
    _child = null;
    super.forgetChild(child);
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    _rebuild();
    assert(_child != null);
  }

  @override
  void update(RenderObjectToWidgetAdapter<T> newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _rebuild();
  }

  // When we are assigned a new widget, we store it here
  // until we are ready to update to it.
  Widget? _newWidget;

  @override
  void performRebuild() {
    if (_newWidget != null) {
      // _newWidget can be null if, for instance, we were rebuilt
      // due to a reassemble.
      final Widget newWidget = _newWidget!;
      _newWidget = null;
      update(newWidget as RenderObjectToWidgetAdapter<T>);
    }
    super.performRebuild();
    assert(_newWidget == null);
  }

  void _rebuild() {
    try {
      _child = updateChild(_child, widget.child, _rootChildSlot);
    } catch (exception, stack) {
      final FlutterErrorDetails details = FlutterErrorDetails(
        exception: exception,
        stack: stack,
        library: 'widgets library',
        context: ErrorDescription('attaching to the render tree'),
      );
      FlutterError.reportError(details);
      final Widget error = ErrorWidget.builder(details);
      _child = updateChild(null, error, _rootChildSlot);
    }
  }

  @override
  ContainerRenderObjectMixin<RenderBox, ContainerBoxParentData<RenderBox>> get renderObject =>
      super.renderObject as ContainerRenderObjectMixin<RenderBox, ContainerBoxParentData<RenderBox>>;

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {
    assert(renderObject.debugValidateChild(child));
    renderObject.add(child as RenderBox);
  }

  @override
  void moveRenderObjectChild(RenderObject child, Object? oldSlot, Object? newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    renderObject.remove(child as RenderBox);
  }
}

abstract class WidgetElement extends dom.Element {
  late Widget _widget;
  _WebFAdapterWidgetState? _state;

  WidgetElement(
    BindingContext? context, {
    Map<String, dynamic>? defaultStyle,
    bool isReplacedElement = false,
    // WidgetElement Adds repaintBoundary by default to prevent the internal paint process from affecting the outside.
    // If a lot of WidgetElement is used in a scene, you need to modify the default repaintBoundary according to the scene analysis.
    // Otherwise it will cause performance problems by creating most layers.
    bool isDefaultRepaintBoundary = true,
  }) : super(
          context,
          defaultStyle: defaultStyle,
          isReplacedElement: isReplacedElement,
          isDefaultRepaintBoundary: isDefaultRepaintBoundary,
        ) {
    WidgetsFlutterBinding.ensureInitialized();
    _state = _WebFAdapterWidgetState(this, attributes, childNodes);
    _widget = _WebFAdapterWidget(_state!);
  }

  Widget build(BuildContext context, Map<String, String> attributes, List<Widget> children);

  // The render object is inserted by Flutter framework when element is WidgetElement.
  @override
  dom.RenderObjectManagerType get renderObjectManagerType => dom.RenderObjectManagerType.FLUTTER_ELEMENT;

  @override
  void didDetachRenderer() {
    super.didDetachRenderer();
  }

  @override
  void didAttachRenderer() {
    // Children of WidgetElement should insert render object by Flutter Framework.
    _attachWidget(_widget);
  }

  @override
  void removeAttribute(String key) {
    super.removeAttribute(key);
    if (_state != null) {
      _state!.onAttributeChanged(attributes);
    }
  }

  @override
  void setAttribute(String key, value) {
    super.setAttribute(key, value);
    if (_state != null) {
      _state!.onAttributeChanged(attributes);
    }
  }

  @override
  dom.Node appendChild(dom.Node child) {
    super.appendChild(child);

    if (_state != null) {
      _state!.onChildrenChanged(childNodes);
    }

    return child;
  }

  @override
  dom.Node removeChild(dom.Node child) {
    super.removeChild(child);

    if (_state != null) {
      _state!.onChildrenChanged(children);
    }

    return child;
  }

  RenderObjectElement? renderObjectElement;

  void _attachWidget(Widget widget) {
    RenderObjectElement rootFlutterElement = ownerDocument.controller.rootFlutterElement;

    WebFRenderObjectToWidgetAdapter adaptor = WebFRenderObjectToWidgetAdapter(
        child: widget,
        container: renderBoxModel as ContainerRenderObjectMixin<RenderBox, ContainerBoxParentData<RenderBox>>);

    ownerDocument.controller.view.addWidgetElement(this);

    Element? parentFlutterElement;
    if (parentNode is WidgetElement) {
      parentFlutterElement = (parentNode as WidgetElement).renderObjectElement;
    } else {
      parentFlutterElement = (parentNode as dom.Element).flutterElement;
    }

    renderObjectElement = adaptor.attachToRenderTree(rootFlutterElement.owner!,
        (parentFlutterElement ?? rootFlutterElement) as RenderObjectElement, parentFlutterElement == null);
  }

  @override
  void dispose() {
    super.dispose();
    if (renderObjectElement != null) {
      deactivate();
    }
  }

  void deactivate() {
    assert(renderObjectElement != null);
    deactivateRecursively(renderObjectElement!);
  }

  void deactivateRecursively(Element element) {
    element.deactivate();
    element.visitChildren(deactivateRecursively);
  }
}

class _WebFAdapterWidget extends StatefulWidget {
  final _WebFAdapterWidgetState _state;

  _WebFAdapterWidget(this._state);

  @override
  State<StatefulWidget> createState() {
    return _state;
  }
}

class _WebFAdapterWidgetState extends State<_WebFAdapterWidget> {
  Map<String, String> _attributes;
  final WidgetElement _element;
  late List<dom.Node> _childNodes;

  _WebFAdapterWidgetState(this._element, this._attributes, this._childNodes) {}

  void onAttributeChanged(Map<String, String> attributes) {
    if (mounted) {
      setState(() {
        _attributes = attributes;
      });
    } else {
      _attributes = attributes;
    }
  }

  List<Widget> convertNodeListToWidgetList(List<dom.Node> childNodes) {
    List<Widget> children = List.generate(childNodes.length, (index) {
      if (childNodes[index] is WidgetElement) {
        _WebFAdapterWidgetState state = (childNodes[index] as WidgetElement)._state!;
        return state.build(context);
      } else {
        return childNodes[index].flutterWidget ??
            WebFElementToWidgetAdaptor(childNodes[index], key: Key(index.toString()));
      }
    });

    return children;
  }

  void onChildrenChanged(List<dom.Node> childNodes) {
    if (mounted) {
      setState(() {
        _childNodes = childNodes;
      });
    } else {
      _childNodes = childNodes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _element.build(context, _attributes, convertNodeListToWidgetList(_childNodes));
  }
}
