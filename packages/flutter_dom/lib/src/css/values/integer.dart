/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */

// CSS Values and Units: https://drafts.csswg.org/css-values-3/#integers
class CSSInteger {
  static int? parseInteger(String value) {
    return int.tryParse(value);
  }

  static bool isInteger(String value) {
    return int.tryParse(value) != null;
  }
}
