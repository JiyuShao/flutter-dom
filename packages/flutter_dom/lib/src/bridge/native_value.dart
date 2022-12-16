/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */
import 'dart:collection';

enum JSValueType {
  TAG_STRING,
  TAG_INT,
  TAG_BOOL,
  TAG_NULL,
  TAG_FLOAT64,
  TAG_JSON,
  TAG_POINTER,
  TAG_FUNCTION,
  TAG_ASYNC_FUNCTION
}

typedef AnonymousNativeFunction = dynamic Function(List<dynamic> args);
typedef AsyncAnonymousNativeFunction = Future<dynamic> Function(
    List<dynamic> args);

int _functionId = 0;
LinkedHashMap<int, AnonymousNativeFunction> _functionMap = LinkedHashMap();
LinkedHashMap<int, AsyncAnonymousNativeFunction> _asyncFunctionMap =
    LinkedHashMap();

AnonymousNativeFunction? getAnonymousNativeFunctionFromId(int id) {
  return _functionMap[id];
}

AsyncAnonymousNativeFunction? getAsyncAnonymousNativeFunctionFromId(int id) {
  return _asyncFunctionMap[id];
}

void removeAnonymousNativeFunctionFromId(int id) {
  _functionMap.remove(id);
}

void removeAsyncAnonymousNativeFunctionFromId(int id) {
  _asyncFunctionMap.remove(id);
}
