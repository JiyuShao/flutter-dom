/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
import 'package:flutter_dom/css.dart';

mixin CSSBoxShadowMixin on RenderStyle {
  List<CSSBoxShadow>? _boxShadow;
  set boxShadow(List<CSSBoxShadow>? value) {
    if (value == _boxShadow) return;
    _boxShadow = value;
    renderBoxModel?.markNeedsPaint();
  }

  List<CSSBoxShadow>? get boxShadow => _boxShadow;

  @override
  List<FlutterDomBoxShadow>? get shadows {
    if (boxShadow == null) {
      return null;
    }
    List<FlutterDomBoxShadow> result = [];
    for (CSSBoxShadow shadow in boxShadow!) {
      result.add(shadow.computedBoxShadow);
    }
    return result;
  }
}
