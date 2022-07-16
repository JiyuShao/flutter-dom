// ignore_for_file: avoid_web_libraries_in_flutter
import 'package:js/js.dart';

const libraryName = '__FLUTTER_DOM_POLYFILL__.JsRuntimePolyfill';

// get all runtime ids
@JS('$libraryName.getAllRuntimeIds')
external List<String> getAllRuntimeIds();

// create js runtime
@JS('$libraryName.createRuntime')
external String createRuntime();

//
@JS('$libraryName.evaluate')
external dynamic evaluate(String instanceId, String code);

// destory js runtime
@JS('$libraryName.destoryRuntime')
external String destoryRuntime(String instanceId);
