/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'package:flutter_dom/devtools.dart';

class InspectRuntimeModule extends IsolateInspectorModule {
  InspectRuntimeModule(IsolateInspectorServer server) : super(server);

  @override
  String get name => 'Runtime';

  @override
  void receiveFromFrontend(int? id, String method, Map<String, dynamic>? params) {
    callNativeInspectorMethod(id, method, params);
  }
}
