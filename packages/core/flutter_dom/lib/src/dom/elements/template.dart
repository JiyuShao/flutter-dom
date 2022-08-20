/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */
import 'package:flutter_dom/css.dart';
import 'package:flutter_dom/dom.dart';
import 'package:flutter_dom/foundation.dart';

const String TEMPLATE = 'TEMPLATE';

const Map<String, dynamic> _defaultStyle = {
  DISPLAY: NONE,
};

class TemplateElement extends Element {
  TemplateElement([BindingContext? context]) : super(context, defaultStyle: _defaultStyle);
}
