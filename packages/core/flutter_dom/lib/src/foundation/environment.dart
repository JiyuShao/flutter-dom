/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

String? _flutterDomTemporaryPath;
Future<String> getFlutterDomTemporaryPath() async {
  if (_flutterDomTemporaryPath == null) {
    String? temporaryDirectory = await getFlutterDomMethodChannel().invokeMethod<String>('getTemporaryDirectory');
    if (temporaryDirectory == null) {
      throw FlutterError('Can\'t get temporary directory from native side.');
    }
    _flutterDomTemporaryPath = temporaryDirectory;
  }
  return _flutterDomTemporaryPath!;
}

MethodChannel _methodChannel = const MethodChannel('flutterDom');
MethodChannel getFlutterDomMethodChannel() {
  return _methodChannel;
}
