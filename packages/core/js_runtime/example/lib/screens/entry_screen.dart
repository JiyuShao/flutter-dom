/*
 * 入口页面
 * @Author: Jiyu Shao
 * @Date: 2021-06-29 17:53:00
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-14 10:40:08
 */
import 'package:flutter/material.dart';
import 'package:js_runtime_example/widgets/page_scaffold/page_scaffold.dart';

class EntryScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/';

  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  Widget build(BuildContext context) {
    return const PageScaffold(body: Text("Entry Page"));
  }
}
