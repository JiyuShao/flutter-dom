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

    testWidgets('Support variable defination and adding', (tester) async {
      jsRuntime.evaluate("let a = 1");
      dynamic result1 = jsRuntime.evaluate("a++");
      expect(result1, 1);

      dynamic result2 = jsRuntime.evaluate("a++");
      expect(result2, 2);
    });

    testWidgets('Support throw error', (tester) async {
      try {
        jsRuntime.evaluate("throw new Error(123)");
      } catch (e) {
        expect(e.toString().contains('123'), true);
      }
    });

    testWidgets('Support promise value', (tester) async {
      dynamic result = jsRuntime.evaluate("""
        new Promise((resolve) => {
          for(let i = 0; i < 10000; i++){}
          resolve(true);
        })
      """);
      expect(result is Future, true);
      expect(await result, true);
    });

    tearDownAll(() async {
      await Future.delayed(const Duration(seconds: 1000), () {});
      jsRuntime.dispose();
    });
  });
}
