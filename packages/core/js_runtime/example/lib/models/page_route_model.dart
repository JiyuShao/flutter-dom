/*
 * 路由相关数据
 * @Author: Jiyu Shao
 * @Date: 2021-06-30 15:29:29
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-14 10:41:48
 */
import 'package:flutter/material.dart';
import 'package:js_runtime_example/screens/error_screen.dart';
import 'package:js_runtime_example/screens/js_example_screen.dart';
import 'package:js_runtime_example/screens/not_found_screen.dart';
import 'package:js_runtime_example/screens/entry_screen.dart';
import 'package:js_runtime_example/utils/routes/page_routes/fade_page_route.dart';

// 路由配置
class PageRouteModel {
  PageRouteModel({
    required this.path,
    required this.routeGenerator,
  });

  // 当前路由路径
  final String path;
  // 当前路由创建方法
  final Route<dynamic>? Function(RouteSettings settings) routeGenerator;

  Map<String, dynamic> toJson() {
    return {
      "path": path,
    };
  }
}

// 页面路径配置
List<PageRouteModel> routeListConfig = [
  // 首页页面路径
  PageRouteModel(
    path: EntryScreen.routeName,
    routeGenerator: (_) => FadePageRoute(
      pageBuilder: (_, __, ___) => const EntryScreen(),
      settings: const RouteSettings(name: EntryScreen.routeName),
    ),
  ),
  // JS 示例页面路径
  PageRouteModel(
    path: JSExampleScreen.routeName,
    routeGenerator: (_) => FadePageRoute(
      pageBuilder: (_, __, ___) => const JSExampleScreen(),
      settings: const RouteSettings(name: JSExampleScreen.routeName),
    ),
  ),
];

// 错误路由
PageRouteModel errorRouteConfig = PageRouteModel(
  path: ErrorScreen.routeName,
  routeGenerator: (_) => FadePageRoute(
    pageBuilder: (_, __, ___) => const ErrorScreen(),
    settings: const RouteSettings(name: ErrorScreen.routeName),
  ),
);

// 404 路由
PageRouteModel notFoundRouteConfig = PageRouteModel(
  path: NotFoundScreen.routeName,
  routeGenerator: (_) => FadePageRoute(
    pageBuilder: (_, __, ___) => const NotFoundScreen(),
    settings: const RouteSettings(name: NotFoundScreen.routeName),
  ),
);
