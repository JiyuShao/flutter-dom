import 'dart:async';

abstract class RuntimeInterface {
  static bool debugEnabled = true;
  static Duration eventLoopDuration = const Duration(milliseconds: 100);

  // must wait before calling other functions
  Future get waitUntilInited => Future.value();

  // evaluate code
  dynamic evaluate(String code) {
    return "";
  }

  void postMessage(List<String> args) async {}

  void onMessage(dynamic Function(List<String> args) fn) {}

  void dispose() {}
}
