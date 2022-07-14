import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:js_runtime/js_runtime.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('Native Testing', () {
    late JsRuntime jsRuntime;
    setUp(() {
      jsRuntime = JsRuntime();
    });

    test('variable defination and adding is correct', () {
      JsRuntime jsRuntime1 = JsRuntime();

      jsRuntime1.evaluate("let result = 1");
      EvalResult result1 = jsRuntime.evaluate("result++");
      expect(result1.isError, false);
      expect(result1.isPromise, false);
      expect(result1.stringResult, "1");
    });

    test('variable defination and adding is correct', () {
      JsRuntime jsRuntime = JsRuntime();

      jsRuntime.evaluate("let result = 1");
      EvalResult result1 = jsRuntime.evaluate("result++");
      expect(result1.isError, false);
      expect(result1.isPromise, false);
      expect(result1.stringResult, "1");

      EvalResult result2 = jsRuntime.evaluate("result++");
      expect(result2.isError, false);
      expect(result2.isPromise, false);
      expect(result2.stringResult, "2");
    });

    tearDown(() {
      jsRuntime.dispose();
    });
  });
}
