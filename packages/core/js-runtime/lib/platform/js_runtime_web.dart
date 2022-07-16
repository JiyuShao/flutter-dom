import 'package:js_runtime/common/logger.dart';
import 'package:js_runtime/common/polyfill.dart' as polyfill;
import 'package:js_runtime/js_runtime.dart';

class JsRuntime extends RuntimeInterface {
  String? _instanceId;

  JsRuntime() {
    loggerNoStack.d("Creating JsRuntime...");
    _instanceId = polyfill.createRuntime();
    loggerNoStack.d("JsRuntime Created($_instanceId)");
  }

  @override
  Future<EvalResult> evaluate(String code) {
    loggerNoStack.d("Evaluate JsRuntime($_instanceId): $code");
    if (_instanceId != null) {
      dynamic result = polyfill.evaluate(_instanceId!, code);
      print('### $result');
    }
    return Future.value(EvalResult(""));
  }

  @override
  void dispose() {
    loggerNoStack.d("Destorying JsRuntime($_instanceId)");
    if (_instanceId != null) {
      polyfill.destoryRuntime(_instanceId!);
      _instanceId = null;
    }
  }
}
