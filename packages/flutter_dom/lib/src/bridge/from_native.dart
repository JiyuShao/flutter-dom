/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-2022.08 The WebF authors. All rights reserved.
 * Copyright (C) 2022.08-present The FlutterDOM authors. All rights reserved.
 */

import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter_dom/bridge.dart';
import 'package:flutter_dom/launcher.dart';
import 'package:flutter_dom/module.dart';
import 'package:flutter_dom/src/module/performance_timing.dart';

// Register InvokeModule
typedef DartAsyncModuleCallback = void Function(
  int contextId,
  String? errmsg,
  String? json,
);

String _invokeModule(
  int contextId,
  String moduleName,
  String method,
  String? params,
  DartAsyncModuleCallback callback,
) {
  FlutterDomController controller =
      FlutterDomController.getControllerOfJSContextId(contextId)!;
  String result = '';

  try {
    void invokeModuleCallback({String? error, data}) {
      // To make sure Promise then() and catch() executed before Promise callback called at JavaScript side.
      // We should make callback always async.
      Future.microtask(() {
        if (error != null) {
          callback(contextId, error.toString(), null);
        } else {
          callback(contextId, null, jsonEncode(data));
        }
      });
    }

    result = controller.module.moduleManager.invokeModule(
      moduleName,
      method,
      (params != null && params != '""') ? jsonDecode(params) : null,
      invokeModuleCallback,
    );
  } catch (e, stack) {
    String error = '$e\n$stack';
    callback(contextId, error.toString(), null);
  }

  return result;
}

// Register reloadApp
void _reloadApp(int contextId) async {
  FlutterDomController controller =
      FlutterDomController.getControllerOfJSContextId(contextId)!;

  try {
    await controller.reload();
  } catch (e, stack) {
    print('Dart Error: $e\n$stack');
  }
}

typedef DartAsyncCallback = void Function(int contextId, String? errmsg);
typedef DartRAFAsyncCallback = void Function(
  int contextId,
  double data,
  String? errmsg,
);

// Register requestBatchUpdate
void _requestBatchUpdate(int contextId) {
  FlutterDomController? controller =
      FlutterDomController.getControllerOfJSContextId(contextId);
  return controller?.module.requestBatchUpdate();
}

// Register setTimeout
int _setTimeout(
  int contextId,
  DartAsyncCallback callback,
  int timeout,
) {
  FlutterDomController controller =
      FlutterDomController.getControllerOfJSContextId(contextId)!;

  return controller.module.setTimeout(timeout, () {
    DartAsyncCallback func = callback;

    void _runCallback() {
      try {
        func(contextId, null);
      } catch (e, stack) {
        func(contextId, 'Error: $e\n$stack');
      }
    }

    // Pause if flutterDom page paused.
    if (controller.paused) {
      controller.pushPendingCallbacks(_runCallback);
    } else {
      _runCallback();
    }
  });
}

// Register setInterval

int _setInterval(
  int contextId,
  DartAsyncCallback callback,
  int timeout,
) {
  FlutterDomController controller =
      FlutterDomController.getControllerOfJSContextId(contextId)!;
  return controller.module.setInterval(timeout, () {
    void _runCallbacks() {
      DartAsyncCallback func = callback;
      try {
        func(contextId, null);
      } catch (e, stack) {
        func(contextId, 'Dart Error: $e\n$stack');
      }
    }

    // Pause if flutterDom page paused.
    if (controller.paused) {
      controller.pushPendingCallbacks(_runCallbacks);
    } else {
      _runCallbacks();
    }
  });
}

void _clearTimeout(int contextId, int timerId) {
  FlutterDomController controller =
      FlutterDomController.getControllerOfJSContextId(contextId)!;
  return controller.module.clearTimeout(timerId);
}

// Register requestAnimationFrame
int _requestAnimationFrame(int contextId, DartRAFAsyncCallback callback) {
  FlutterDomController controller =
      FlutterDomController.getControllerOfJSContextId(contextId)!;
  return controller.module.requestAnimationFrame((double highResTimeStamp) {
    void _runCallback() {
      DartRAFAsyncCallback func = callback;
      try {
        func(contextId, highResTimeStamp, null);
      } catch (e, stack) {
        func(contextId, highResTimeStamp, 'Error: $e\n$stack');
      }
    }

    // Pause if flutterDom page paused.
    if (controller.paused) {
      controller.pushPendingCallbacks(_runCallback);
    } else {
      _runCallback();
    }
  });
}

// Register cancelAnimationFrame
void _cancelAnimationFrame(int contextId, int timerId) {
  FlutterDomController controller =
      FlutterDomController.getControllerOfJSContextId(contextId)!;
  controller.module.cancelAnimationFrame(timerId);
}

// Register getScreen
int _getScreen() {
  ui.Size size = ui.window.physicalSize;
  return createScreen(size.width / ui.window.devicePixelRatio,
      size.height / ui.window.devicePixelRatio);
}

// Register flushUICommand
void _flushUICommand() {
  if (kProfileMode) {
    PerformanceTiming.instance().mark(PERF_DOM_FLUSH_UI_COMMAND_START);
  }
  flushUICommand();
  if (kProfileMode) {
    PerformanceTiming.instance().mark(PERF_DOM_FLUSH_UI_COMMAND_END);
  }
}

// Register performanceGetEntries
PerformanceTiming? _performanceGetEntries(int contextId) {
  if (kProfileMode) {
    return PerformanceTiming.instance();
  }
  return null;
}

// Register onJsError
void _onJsError(int contextId, String msg) {
  FlutterDomController controller =
      FlutterDomController.getControllerOfJSContextId(contextId)!;
  JSErrorHandler? handler = controller.onJSError;
  if (handler != null) {
    handler(msg);
  }
}

// Register onJsLog
void _onJsLog(int contextId, int level, String msg) {
  FlutterDomController? controller =
      FlutterDomController.getControllerOfJSContextId(contextId);
  if (controller != null) {
    JSLogHandler? jsLogHandler = controller.onJSLog;
    if (jsLogHandler != null) {
      jsLogHandler(level, msg);
    }
  }
}

final List<Function> _dartMethods = [
  _invokeModule,
  _requestBatchUpdate,
  _reloadApp,
  _setTimeout,
  _setInterval,
  _clearTimeout,
  _requestAnimationFrame,
  _cancelAnimationFrame,
  _getScreen,
  _flushUICommand,
  _performanceGetEntries,
  _onJsError,
  _onJsLog,
];

void registerDartMethodsToNative() {
  print("registerDartMethodsToNative: $_dartMethods");
  // TODO:
}
