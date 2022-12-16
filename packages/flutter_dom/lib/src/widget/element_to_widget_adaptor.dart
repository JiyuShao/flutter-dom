/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
import 'package:flutter/widgets.dart';
import 'package:flutter_dom/css.dart';
import 'package:flutter_dom/dom.dart' as dom;
import 'package:flutter_dom/rendering.dart';

class FlutterDomElementToWidgetAdaptor extends RenderObjectWidget {
  final dom.Node _flutterDomNode;

  FlutterDomElementToWidgetAdaptor(this._flutterDomNode, {Key? key}) : super(key: key) {
    _flutterDomNode.flutterWidget = this;
  }

  @override
  RenderObjectElement createElement() {
    _flutterDomNode.flutterElement = FlutterDomElementToFlutterElementAdaptor(this);
    return _flutterDomNode.flutterElement as RenderObjectElement;
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    // Children of custom element need RenderFlowLayout nesting,
    // otherwise the parent render layout will not be called when setting properties.
    if (_flutterDomNode is dom.Element) {
      CSSRenderStyle renderStyle = CSSRenderStyle(target: _flutterDomNode as dom.Element);
      RenderFlowLayout renderFlowLayout = RenderFlowLayout(renderStyle: renderStyle);
      renderFlowLayout.insert(_flutterDomNode.renderer!);
      return renderFlowLayout;
    } else {
      return _flutterDomNode.renderer!;
    }
  }
}

class FlutterDomElementToFlutterElementAdaptor extends RenderObjectElement {
  FlutterDomElementToFlutterElementAdaptor(RenderObjectWidget widget) : super(widget);

  @override
  FlutterDomElementToWidgetAdaptor get widget => super.widget as FlutterDomElementToWidgetAdaptor;

  @override
  void mount(Element? parent, Object? newSlot) {
    widget._flutterDomNode.createRenderer();
    super.mount(parent, newSlot);

    widget._flutterDomNode.ensureChildAttached();

    if (widget._flutterDomNode is dom.Element) {
      dom.Element element = (widget._flutterDomNode as dom.Element);
      element.applyStyle(element.style);

      if (element.renderer != null) {
        // Flush pending style before child attached.
        element.style.flushPendingProperties();
      }
    }
  }

  @override
  void unmount() {
    // Flutter element unmount call dispose of _renderObject, so we should not call dispose in unmountRenderObject.
    dom.Node node = widget._flutterDomNode;

    if (node is dom.Element) {
      node.unmountRenderObject(dispose: false);
    }

    super.unmount();
  }

  @override
  void insertRenderObjectChild(RenderObject child, Object? slot) {}

  @override
  void moveRenderObjectChild(covariant RenderObject child, covariant Object? oldSlot, covariant Object? newSlot) {}
}
