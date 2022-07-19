// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'package:js/js.dart';

const libraryName = '__FLUTTER_DOM_POLYFILL__.JsRuntimePolyfill';

// get all runtime ids
@JS('$libraryName.getAllRuntimeIds')
external List<String> getAllRuntimeIds();

// create js runtime
@JS('$libraryName.createRuntime')
external dynamic createRuntimeOrigional();

Future<String> createRuntime() async {
  var result = await promiseToFuture(createRuntimeOrigional());
  return result;
}

// sync evaluate code
@JS('$libraryName.evaluate')
external dynamic evaluateSyncOrigional(String instanceId, String code);

dynamic evaluate(String instanceId, String code) {
  dynamic result = evaluateSyncOrigional(instanceId, code);
  if (result.isPromise == true) {
    return promiseToFuture(result.result);
  }
  return result.result;
}

// sync evaluate code
@JS('$libraryName.executePendingJobs')
external int executePendingJobs(String instanceId);

// destory js runtime
@JS('$libraryName.destoryRuntime')
external void destoryRuntime(String instanceId);
