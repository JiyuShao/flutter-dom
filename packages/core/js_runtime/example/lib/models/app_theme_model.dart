/*
 * 应用主题配置
 * @Author: Jiyu Shao
 * @Date: 2021-07-07 19:25:46
 * @Last Modified by: Jiyu Shao
 * @Last Modified time: 2022-07-14 10:37:19
 * @Reference https://stackoverflow.com/questions/49172746/is-it-possible-extend-themedata-in-flutter
 */
import 'package:flutter/material.dart';

class AppThemeModel {
  // 动画持续时间
  static const int baseAnimationDuration = 120;

  // MaterialApp theme 初始化数据, 注意跟 Theme.of(context) 拿到的数据不同
  static ThemeData materialTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    backgroundColor: Colors.white,
    dialogBackgroundColor: Colors.black38,
    platform: TargetPlatform.iOS,
  );
}

// extension BuildContextAppThemeModelExtension on BuildContext {
//   AppThemeModel get theme {
//     return watch<AppThemeModel>();
//   }
// }
