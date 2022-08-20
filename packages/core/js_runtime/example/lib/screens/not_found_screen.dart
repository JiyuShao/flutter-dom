/*
 * 404 页面
 * @Author: Jiyu Shao
 * @Date: 2021-06-29 17:53:00
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-14 10:15:02
 */
import 'package:flutter/material.dart';
import 'package:js_runtime_example/widgets/page_scaffold/page_scaffold.dart';

class NotFoundScreen extends StatefulWidget {
  // 路由名称
  static const routeName = '/not_found';

  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
        body: Center(
      child: Text('ERROR'),
    ));
  }
}
