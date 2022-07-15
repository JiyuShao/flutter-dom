import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:js_runtime/js_runtime.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration testing', () {
    late JsRuntime jsRuntime;

    // Throw error in setUp will cause All tests passed.
    setUp(() {
      jsRuntime = JsRuntime();
    });

    testWidgets('variable defination and adding', (tester) async {
      JsRuntime jsRuntime = JsRuntime();

      // await jsRuntime.evaluate("let a = 1");
      EvalResult result = await jsRuntime.evaluate("let a = 1;a++");
      expect(result.isError, true);
      expect(result.isPromise, false);
      expect(result.stringResult, "1");
    });

    testWidgets('variable defination and adding', (tester) async {
      JsRuntime jsRuntime = JsRuntime();

      await jsRuntime.evaluate("let a = 1");
      EvalResult result1 = await jsRuntime.evaluate("a++");
      expect(result1.isError, false);
      expect(result1.isPromise, false);
      expect(result1.stringResult, "1");

      EvalResult result2 = await jsRuntime.evaluate("a++");
      expect(result2.isError, false);
      expect(result2.isPromise, false);
      expect(result2.stringResult, "2");
    });

    tearDown(() async {
      // jsRuntime.dispose();
      await Future.delayed(const Duration(seconds: 1000), () {});
    });
  });
}
