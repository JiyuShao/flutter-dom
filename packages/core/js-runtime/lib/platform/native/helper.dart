// 转换 flutter_qjs 的值为 Dart 值
import 'package:flutter_qjs/flutter_qjs.dart';

dynamic jsToDart(jsValue) {
  if (jsValue is List) {
    return jsValue.map(jsToDart).toList();
  }
  if (jsValue is Map) {
    return Map.fromIterable(
      jsValue.keys,
      value: (key) => jsToDart(jsValue[key]),
    );
  }

  if (jsValue is bool ||
      jsValue is int ||
      jsValue is double ||
      jsValue is String) {
    return jsValue;
  }

  if (jsValue is Future || jsValue is JSError) {
    return {};
  }
  return null;
}
