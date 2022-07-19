import 'dart:async';

import 'package:js_runtime/common/logger.dart';
import 'package:js_runtime/common/polyfill.dart' as polyfill;
import 'package:js_runtime/js_runtime.dart';

class JsRuntime extends RuntimeInterface {
  String? _instanceId;
  Future? _initPromise;
  Timer? _eventLoopTimer;

  JsRuntime() {
    _init();
  }

  _init() async {
    loggerNoStack.d("Creating JsRuntime...");
    _initPromise = polyfill.createRuntime();
    _instanceId = await _initPromise;
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
  void dispose() {
    if (_instanceId == null) {
      throw "JsRuntime not inited, please using \"await waitUntilInited\"";
    }
    loggerNoStack.d("Destorying JsRuntime($_instanceId)");
    _eventLoopTimer?.cancel();
    polyfill.destoryRuntime(_instanceId!);
    _instanceId = null;
  }
}
