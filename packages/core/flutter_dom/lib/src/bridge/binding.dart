/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */

// Bind the JavaScript side object,
// provide interface such as property setter/getter, call a property as function.
import 'package:flutter_dom/bridge.dart';
import 'package:flutter_dom/dom.dart';
import 'package:flutter_dom/foundation.dart';

// We have some integrated built-in behavior starting with string prefix reuse the callNativeMethod implements.
const String AnonymousFunctionCallPreFix = '_anonymous_fn_';
const String AsyncAnonymousFunctionCallPreFix = '_anonymous_async_fn_';
const String GetPropertyMagic = '%g';
const String SetPropertyMagic = '%s';

// TODO: 删除了核心逻辑，待完善
// This function receive calling from binding side.
void _invokeBindingMethod(NativeBindingObject nativeBindingObject,
    List<dynamic> returnValue, String method, int argc, List<dynamic> argv) {
  if (method.startsWith(AnonymousFunctionCallPreFix)) {
    int id = int.parse(method.substring(AnonymousFunctionCallPreFix.length));
    AnonymousNativeFunction fn = getAnonymousNativeFunctionFromId(id)!;
    try {
      var result = fn(argv);
    } catch (e, stack) {
      print('$e\n$stack');
    }
    removeAnonymousNativeFunctionFromId(id);
  } else if (method.startsWith(AsyncAnonymousFunctionCallPreFix)) {
    int id =
        int.parse(method.substring(AsyncAnonymousFunctionCallPreFix.length));
    AsyncAnonymousNativeFunction fn =
        getAsyncAnonymousNativeFunctionFromId(id)!;
    int contextId = argv[0];
    Function callback = argv[1];
    Future<dynamic> p = fn(argv.sublist(2));
    p.then((result) {
      callback(result, contextId, null);
      removeAsyncAnonymousNativeFunctionFromId(id);
    }).catchError((e, stack) {
      String errorMessage = '$e';
      callback(null, contextId, errorMessage);
      removeAsyncAnonymousNativeFunctionFromId(id);
    });
  }
}

// Dispatch the event to the binding side.
void _dispatchBindingEvent(Event event) {
  // TODO: 删除了核心逻辑，待完善
  int? contextId = event.target?.contextId;
  if (contextId != null) {
    emitUIEvent(contextId, null as dynamic, event);
  }
}

abstract class BindingBridge {
  static void _bindObject(BindingObject object) {}

  static void _unbindObject(BindingObject object) {}

  static void setup() {
    BindingObject.bind = _bindObject;
    BindingObject.unbind = _unbindObject;
  }

  static void teardown() {
    BindingObject.bind = null;
    BindingObject.unbind = null;
  }

  static void listenEvent(EventTarget target, String type) {
    assert(_debugShouldNotListenMultiTimes(target, type),
        'Failed to listen event \'$type\' for $target, for which is already bound.');
    target.addEventListener(type, _dispatchBindingEvent);
  }

  static void unlistenEvent(EventTarget target, String type) {
    assert(_debugShouldNotUnlistenEmpty(target, type),
        'Failed to unlisten event \'$type\' for $target, for which is already unbound.');
    target.removeEventListener(type, _dispatchBindingEvent);
  }

  static bool _debugShouldNotListenMultiTimes(EventTarget target, String type) {
    Map<String, List<EventHandler>> eventHandlers = target.getEventHandlers();
    List<EventHandler>? handlers = eventHandlers[type];
    if (handlers != null) {
      return !handlers.contains(_dispatchBindingEvent);
    }
    return true;
  }

  static bool _debugShouldNotUnlistenEmpty(EventTarget target, String type) {
    Map<String, List<EventHandler>> eventHandlers = target.getEventHandlers();
    List<EventHandler>? handlers = eventHandlers[type];
    if (handlers != null) {
      return handlers.contains(_dispatchBindingEvent);
    }
    return false;
  }
}
