import 'dart:async';

import 'package:js_runtime/common/logger.dart';
import 'package:js_runtime/common/runtime.dart';
import './polyfill.dart' as polyfill;

class JsRuntime extends RuntimeInterface {
  String? _instanceId;
  Future? _initPromise;
  Timer? _eventLoopTimer;

  JsRuntime() {
    _initPromise = _init();
  }

  _init() async {
    loggerNoStack.d("Loading JsRuntime Polyfill...");
    await polyfill.loadPolyfillScript();
    loggerNoStack.d("Creating JsRuntime...");
    _instanceId = await polyfill.createRuntime();
    loggerNoStack.d("JsRuntime Created($_instanceId)");
    _defineEventLoop();
  }

  _defineEventLoop() {
    Timer.periodic(RuntimeInterface.eventLoopDuration, (timer) {
      _eventLoopTimer = timer;
      polyfill.executePendingJobs(_instanceId!);
    });
  }

  @override
  Future get waitUntilInited => _initPromise ?? Future.value();

  @override
  dynamic evaluate(String code) {
    if (_instanceId == null) {
      throw "JsRuntime not inited, please using \"await waitUntilInited\"";
    }
    loggerNoStack.d("Evaluate JsRuntime($_instanceId): $code");
    dynamic result = polyfill.evaluate(_instanceId!, code);
    return result;
  }

  @override
  void postMessage(List<String> args) {}

  @override
  void onMessage(dynamic Function(List<String> args) fn) {}

  @override
  void dispose() {
    if (_instanceId == null) {
      throw "JsRuntime not inited, please using \"await waitUntilInited\"";
    }
    loggerNoStack.d("Destorying JsRuntime($_instanceId)");
    _eventLoopTimer?.cancel();
    _eventLoopTimer = null;
    polyfill.destoryRuntime(_instanceId!);
    _instanceId = null;
  }
}
