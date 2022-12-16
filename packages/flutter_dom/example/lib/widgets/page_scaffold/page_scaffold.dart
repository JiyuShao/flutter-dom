/*
 * 基础页面脚手架
 * @Author: Jiyu Shao
 * @Date: 2021-07-02 17:39:20
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-14 10:32:29
 */
import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  // 页面元素
  final Widget body;
  // 页面标题
  final AppBar? appBar;
  // 悬浮按钮
  final FloatingActionButton? floatingActionButton;
  // 背景颜色
  final Color? backgroundColor;
  // 自定义的 bottomArea
  final Widget? bottomArea;
  // 键盘弹出时是否 resize body
  final bool? resizeToAvoidBottomInset;
  // safeArea的配置
  final Map<String, dynamic>? safeAreaOptions;

  const PageScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.bottomArea,
    this.resizeToAvoidBottomInset,
    this.safeAreaOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 页面元素
    List<Widget> pageBody = [
      Expanded(
        child: body,
      )
    ];

    // 添加自定义的 bottomBar
    if (bottomArea != null) pageBody.add(bottomArea!);

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? Theme.of(context).backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        bottom: safeAreaOptions?['bottom'] == true,
        child: Column(
          children: pageBody,
        ),
      ),
    );
  }
}
