/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */

import 'package:flutter/rendering.dart';
import 'package:flutter_dom/css.dart';

mixin CSSObjectFitMixin on RenderStyle {
  @override
  BoxFit get objectFit => _objectFit ?? BoxFit.fill;
  BoxFit? _objectFit;
  set objectFit(BoxFit? value) {
    if (_objectFit == value) return;
    _objectFit = value;
    renderBoxModel?.markNeedsLayout();
  }

  static BoxFit resolveBoxFit(String fit) {
    switch (fit) {
      case 'contain':
        return BoxFit.contain;

      case 'cover':
        return BoxFit.cover;

      case 'none':
        return BoxFit.none;

      case 'scaleDown':
      case 'scale-down':
        return BoxFit.scaleDown;

      case 'fitWidth':
      case 'fit-width':
        return BoxFit.fitWidth;

      case 'fitHeight':
      case 'fit-height':
        return BoxFit.fitHeight;

      case 'fill':
      default:
        return BoxFit.fill;
    }
  }
}
