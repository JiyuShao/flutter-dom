// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:js_util';
import 'package:js/js.dart';
import './load_script.dart' as load_script;

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
external dynamic evaluateOrigional(String instanceId, String code);

dynamic evaluate(String instanceId, String code) {
  try {
    dynamic resultString = evaluateOrigional(instanceId, code);
    dynamic result = jsonDecode(resultString);
    return result['value'];
  } catch (e) {
    throw Exception(e.toString());
  }
}

// sync evaluate code
@JS('$libraryName.executePendingJobs')
external int executePendingJobs(String instanceId);

// destory js runtime
@JS('$libraryName.destoryRuntime')
external void destoryRuntime(String instanceId);

Future<void> loadPolyfillScript() {
  String url = "http://localhost:3000/JsRuntimePolyfill.js";
  if (load_script.isLoaded(url)) {
    return Future.value();
  }
  return load_script.loadScript(url);
}
