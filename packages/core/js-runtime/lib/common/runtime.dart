import 'dart:async';

import 'package:js_runtime/common/eval_result.dart';

abstract class RuntimeInterface {
  // 是否开启调试模式
  static bool debugEnabled = true;

  String getInstanceId() {
    return "";
  }

  Future<EvalResult> evaluate(String code) {
    return Future.value(EvalResult(""));
  }

  void postMessage(List<String> args) {}

  void onMessage(dynamic Function(List<String> args) fn) {}

  void dispose() {}
}
