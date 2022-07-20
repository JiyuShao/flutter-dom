import 'dart:async';

import 'package:flutter_js/flutter_js.dart' as flutter_js;
import 'package:js_runtime/common/runtime.dart';

// 使用 flutter_js 实现原生的 js 运行环境
class JsRuntime extends RuntimeInterface {
  late flutter_js.JavascriptRuntime _jsRuntime;
  Timer? _eventLoopTimer;

  JsRuntime() {
    _jsRuntime = flutter_js.getJavascriptRuntime();
    _defineEventLoop();
  }

  _defineEventLoop() {
    Timer.periodic(RuntimeInterface.eventLoopDuration, (timer) {
      _eventLoopTimer = timer;
      _jsRuntime.executePendingJob();
    });
  }

  @override
  String getInstanceId() {
    return _jsRuntime.getEngineInstanceId();
  }

  @override
  dynamic evaluate(String code) {
    flutter_js.JsEvalResult result = _jsRuntime.evaluate(code);
    if (result.isPromise) {
      return _jsRuntime
          .handlePromise(result)
          .then((value) => _jsRuntime.convertValue(value));
    }
    return result.rawResult;
  }

  @override
  void postMessage(List<String> args) {
    _jsRuntime.sendMessage(channelName: 'message', args: args);
  }

  @override
  void onMessage(dynamic Function(List<String> args) fn) {
    _jsRuntime.onMessage('message', fn as dynamic);
  }

  @override
  void dispose() {
    _eventLoopTimer?.cancel();
    _eventLoopTimer = null;
    _jsRuntime.dispose();
  }
}
