import 'package:flutter_js/flutter_js.dart' as flutter_js;
import 'package:js_runtime/common/eval_result.dart';
import 'package:js_runtime/common/runtime.dart';

// 使用 flutter_js 实现原生的 js 运行环境
class JsRuntime extends RuntimeInterface {
  late flutter_js.JavascriptRuntime _jsRuntime;

  JsRuntime() {
    _jsRuntime = flutter_js.getJavascriptRuntime();
  }

  @override
  String getInstanceId() {
    return _jsRuntime.getEngineInstanceId();
  }

  @override
  EvalResult evaluate(String code) {
    flutter_js.JsEvalResult result = _jsRuntime.evaluate(code);
    return EvalResult(
      result.stringResult,
      isError: result.isError,
      isPromise: result.isPromise,
    );
  }

  @override
  Future<EvalResult> evaluateAsync(String code) {
    Future<flutter_js.JsEvalResult> resultFuture =
        _jsRuntime.evaluateAsync(code);
    return resultFuture.then((result) => EvalResult(
          result.stringResult,
          isError: result.isError,
          isPromise: result.isPromise,
        ));
  }

  @override
  void sendMessage({
    required String channelName,
    required List<String> args,
  }) {
    _jsRuntime.sendMessage(channelName: channelName, args: args);
  }

  @override
  void onMessage(String channelName, dynamic Function(dynamic args) fn) {
    _jsRuntime.onMessage(channelName, fn);
  }

  @override
  void dispose() {
    _jsRuntime.dispose();
  }
}
