import 'package:flutter/material.dart';
import 'package:js_runtime_example/utils/routes/page_routes/common_page_route_builder.dart';

Widget _transitionsBuilder(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

class FadePageRoute<T> extends CommonPageRouteBuilder<T> {
  FadePageRoute({
    RouteSettings? settings,
    required pageBuilder,
  }) : super(
          settings: settings,
          barrierLabel: 'FadePageRoute',
          pageBuilder: pageBuilder,
          maintainState: false,
          opaque: false,
          barrierDismissible: true,
          transitionsBuilder: _transitionsBuilder,
        );
}
