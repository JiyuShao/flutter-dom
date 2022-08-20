/*
 * JS 示例页面
 * @Author: Jiyu Shao
 * @Date: 2021-06-29 17:53:00
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-19 19:15:34
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dom_example/utils/logger.dart';
import 'package:flutter_dom_example/widgets/page_scaffold/page_scaffold.dart';
import 'package:js_runtime/js_runtime.dart';

class JSExampleScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/js_example';

  const JSExampleScreen({Key? key}) : super(key: key);

  @override
  State<JSExampleScreen> createState() => _JSExampleScreenState();
}

class _JSExampleScreenState extends State<JSExampleScreen> {
  String _result = '';
  late JsRuntime jsRuntime;

  _init() async {
    jsRuntime = JsRuntime();
    await jsRuntime.waitUntilInited;
    jsRuntime.evaluate("let a = 1");
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  dispose() {
    super.dispose();
    jsRuntime.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('JS Evaluate Result: $_result\n'),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  'Click on the big JS Yellow Button to evaluate the expression bellow using the flutter_js plugin'),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "let a = 1; a++;",
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.beach_access,
          color: Colors.blue,
          size: 36.0,
        ),
        onPressed: () async {
          try {
            dynamic result = jsRuntime.evaluate("a++");
            setState(() {
              _result = result.toString();
            });
          } on PlatformException catch (e) {
            loggerNoStack.e('ERRO: ${e.details}');
          }
        },
      ),
    );
  }
}
