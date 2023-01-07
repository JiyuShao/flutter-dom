/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
import 'package:flutter_dom/module.dart';

class LocationModule extends BaseModule {
  @override
  String get name => 'Location';

  LocationModule(ModuleManager? moduleManager) : super(moduleManager);

  String get href => moduleManager!.controller.url;

  @override
  String invoke(String method, params, InvokeModuleCallback callback) {
    switch (method) {
      case 'getHref':
        return href;
      default:
        return '';
    }
  }

  @override
  void dispose() {}
}
