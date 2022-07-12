/*
 * 页面
 * @Author: Jiyu Shao
 * @Date: 2021-06-29 17:53:00
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-12 11:33:35
 */
import 'package:flutter/material.dart';
import 'package:flutter_dom/widgets/page_scaffold/page_scaffold.dart';

class EntryScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/';

  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return const PageScaffold(body: Text("Entry Page"));
  }
}
