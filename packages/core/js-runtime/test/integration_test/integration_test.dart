// import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:js_runtime/js_runtime.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration testing', () {
    late JsRuntime jsRuntime;

    // Throw error in setUp will cause All tests passed.
    setUpAll(() async {
      jsRuntime = JsRuntime();
      await jsRuntime.waitUntilInited;
    });

    // testWidgets('Check running platform', (tester) async {
    //   expect(Platform.isAndroid, false);
    //   expect(Platform.isFuchsia, false);
    //   expect(Platform.isIOS, false);
    //   expect(Platform.isLinux, false);
    //   expect(Platform.isMacOS, false);
    //   expect(Platform.isWindows, false);
    // });

    testWidgets('Support result types(JSON)', (tester) async {
      dynamic result = jsRuntime.evaluate("""
        const supportResultTypes = {
          undefined: undefined,
          nulltype: null,
          boolean: false,
          number1: 123,
          number2: 123.123,
          string: "string",
          symbol: Symbol(),
          function: () => 123,
          promise: new Promise((resolve) => {
            for(let i = 0; i < 10000; i++){}
            resolve(true);
          })
        };
        supportResultTypes;
      """);
      expect(result is Map, true);
      expect(result['undefined'], null);
      expect(result['nulltype'], null);
      expect(result['boolean'], false);
      expect(result['number1'], 123);
      expect(result['number2'], 123.123);
      expect(result['string'], 'string');
      expect(result['function'], null);
      expect(result['promise'], {});
    });

    testWidgets('Support variable defination and adding', (tester) async {
      jsRuntime.evaluate("let add = 1");
      dynamic result1 = jsRuntime.evaluate("add++");
      expect(result1, 1);

      dynamic result2 = jsRuntime.evaluate("add++");
      expect(result2, 2);
    });

    testWidgets('Support throw Exception', (tester) async {
      try {
        jsRuntime.evaluate("throw new Error(123)");
      } catch (e) {
        expect(e is Exception, true);
        expect(e.toString().contains('123'), true);
      }
    });

    tearDownAll(() async {
      await Future.delayed(const Duration(seconds: 1000), () {});
      jsRuntime.dispose();
    });
  });
}
