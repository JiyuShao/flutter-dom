import 'dart:async';

import 'package:js_runtime/common/eval_result.dart';

abstract class RuntimeInterface {
  // 是否开启调试模式
  static bool debugEnabled = true;

  String getInstanceId() {
    return "";
  }

  EvalResult evaluate(String code) {
    return EvalResult("");
  }

  Future<EvalResult> evaluateAsync(String code) {
    return Future.value(EvalResult(""));
  }

  void sendMessage({
    required String channelName,
    required List<String> args,
  }) {}

  void onMessage(String channelName, dynamic Function(dynamic args) fn) {}

  void dispose() {}
}
