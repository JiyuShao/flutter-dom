// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js';

/// A workaround to deep-converting an object from JS to a Dart Object.
Object jsToDart(jsObject) {
  if (jsObject is JsArray || jsObject is Iterable) {
    return jsObject.map(jsToDart).toList();
  }
  if (jsObject.runtimeType.toString() == 'LegacyJavaScriptObject') {
    return Map.fromIterable(
      getObjectKeys(jsObject),
      value: (key) => jsToDart(jsObject[key]),
    );
  }
  return jsObject;
}

List<String> getObjectKeys(dynamic object) {
  var result = context['Object']
      .callMethod('getOwnPropertyNames', [object])
      .toList()
      .cast<String>();
  print('### $result');
  return result;
}
