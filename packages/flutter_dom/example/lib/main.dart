import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dom_example/screens/error_screen.dart';
import 'package:flutter_dom_example/screens/flutter_dom_example_screen.dart';
import 'models/app_theme_model.dart';
import 'utils/logger.dart';
import 'utils/routes/routes_generator.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    //  application quit immediately any time an error is caught by Flutter in release mode
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      // exit(1);
    };
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    runApp(const MyApp());
  }, (Object error, StackTrace stack) {
    loggerNoStack.e('Errors not caught by Flutter: $error $stack');
    // exit(1);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    loggerNoStack.d('初始化应用');
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Flutter DOM Core',
      debugShowCheckedModeBanner: true,
      theme: AppThemeModel.materialTheme,
      // theme: ThemeData.dark(),
      initialRoute: FlutterDommExampleScreen.routeName,
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: (BuildContext context, Widget? widget) {
        Widget error = const ErrorScreen();
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(body: Center(child: error));
        }
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
        if (widget != null) return widget;
        throw ('widget is null');
      },
    );
  }
}
