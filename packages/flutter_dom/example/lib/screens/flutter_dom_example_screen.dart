/*
 * JS 示例页面
 * @Author: Jiyu Shao
 * @Date: 2021-06-29 17:53:00
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-12-15 22:06:28
 */
import 'package:flutter/material.dart';
import 'package:flutter_dom/flutter_dom.dart';

class FlutterDommExampleScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/js_example';

  const FlutterDommExampleScreen({Key? key}) : super(key: key);

  @override
  State<FlutterDommExampleScreen> createState() =>
      _FlutterDommExampleScreenState();
}

class _FlutterDommExampleScreenState extends State<FlutterDommExampleScreen> {
  OutlineInputBorder outlineBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    borderRadius: BorderRadius.all(
      Radius.circular(20.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    final TextEditingController textEditingController = TextEditingController();

    FlutterDom? _flutterDom;
    AppBar appBar = AppBar(
      backgroundColor: Colors.black87,
      titleSpacing: 10.0,
      title: Container(
        height: 40.0,
        child: TextField(
          controller: textEditingController,
          onSubmitted: (value) {
            textEditingController.text = value;
            _flutterDom?.load(FlutterDomBundle.fromUrl(value));
          },
          decoration: InputDecoration(
            hintText: 'Enter URL',
            hintStyle: const TextStyle(color: Colors.black54, fontSize: 16.0),
            contentPadding: const EdgeInsets.all(10.0),
            filled: true,
            fillColor: Colors.grey,
            border: outlineBorder,
            focusedBorder: outlineBorder,
            enabledBorder: outlineBorder,
          ),
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
        ),
      ),
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
    );

    final Size viewportSize = queryData.size;
    return Scaffold(
        appBar: appBar,
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            children: [
              _flutterDom = FlutterDom(
                viewportWidth:
                    viewportSize.width - queryData.padding.horizontal,
                viewportHeight: viewportSize.height -
                    appBar.preferredSize.height -
                    queryData.padding.vertical,
                bundle: FlutterDomBundle.fromUrl(
                    'assets:assets/demos/console-log-demo.js'),
              ),
            ],
          ),
        ));
  }
}
