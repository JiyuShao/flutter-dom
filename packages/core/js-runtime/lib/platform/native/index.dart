import 'package:flutter_qjs/flutter_qjs.dart' as flutter_qjs;
import 'package:js_runtime/common/runtime.dart';

// 使用 flutter_qjs 实现原生的 js 运行环境
class JsRuntime extends RuntimeInterface {
  late flutter_qjs.FlutterQjs _jsRuntime;

  JsRuntime() {
    _jsRuntime = flutter_qjs.FlutterQjs(
      stackSize: 1024 * 1024,
    );
    _defineEventLoop();
  }

  _defineEventLoop() {
    _jsRuntime.dispatch();
  }

  @override
  dynamic evaluate(String code) {
    return _jsRuntime.evaluate(code);
  }

  @override
  void postMessage(List<String> args) {}

  @override
  void onMessage(dynamic Function(List<String> args) fn) {}

  @override
  void dispose() {
    try {
      _jsRuntime.port.close(); // stop dispatch loop
      _jsRuntime.close(); // close engine
    } on flutter_qjs.JSError catch (e) {
      print(e); // catch reference leak exception
    }
  }
}
