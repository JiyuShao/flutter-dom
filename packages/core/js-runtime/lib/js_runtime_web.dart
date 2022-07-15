import 'package:isolated_worker/js_isolated_worker.dart' as js_worker;
import 'package:js_runtime/js_runtime.dart';
import 'package:uuid/uuid.dart';

class JsRuntime extends RuntimeInterface {
  late js_worker.JsIsolatedWorker _jsWorker;
  late String _instanceId;

  JsRuntime() {
    _jsWorker = js_worker.JsIsolatedWorker();
    _instanceId = const Uuid().v4();
  }

  @override
  String getInstanceId() {
    return _instanceId;
  }

  @override
  Future<EvalResult> evaluate(String code) async {
    return _jsWorker.run(
      functionName: ['eval'],
      arguments: code,
    ).then((value) {
      return EvalResult(
        value.toString(),
        isError: false,
        isPromise: false,
      );
    }).catchError((e) {
      return EvalResult(
        e.toString(),
        isError: true,
        isPromise: false,
      );
    });
  }

  @override
  void dispose() {
    _jsWorker.close();
  }
}
