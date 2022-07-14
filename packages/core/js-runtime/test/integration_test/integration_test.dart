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

    testWidgets('variable defination and adding is correct', (tester) async {
      JsRuntime jsRuntime1 = JsRuntime();

      jsRuntime1.evaluate("let result = 1");
      EvalResult result1 = jsRuntime.evaluate("result++");
      expect(result1.isError, false);
      expect(result1.isPromise, false);
      expect(result1.stringResult, "1");
    });

    testWidgets('variable defination and adding is correct', (tester) async {
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
