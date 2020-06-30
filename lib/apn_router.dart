library apn_router;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Router {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void pop<T>([T result]) => navigatorKey.currentState.pop<T>(result);

  static Future<T> nav<T>(PageRoute route) => navigatorKey.currentState.pushNamed<T>(
        route.name,
        arguments: route,
      );

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final currentContext = navigatorKey.currentContext;

    if (settings.arguments is PageRoute) {
      return (settings.arguments as PageRoute).route(currentContext);
    } else {
      return _routeNotFound(settings.name);
    }
  }

  static Route<dynamic> _routeNotFound(String name) => MaterialPageRoute(builder: (_) => _routeNotFoundWidget(name));
}

abstract class PageRoute {
  String get name => "/";

  Widget builder(BuildContext context);

  Route<dynamic> route(BuildContext context) => MaterialPageRoute(
        builder: builder,
        settings: RouteSettings(name: name),
      );
}

class SimplePageRoute extends PageRoute {
  final String name;
  final Widget widget;

  SimplePageRoute(this.name, this.widget);

  @override
  Widget builder(BuildContext context) => widget;
}

class SimpleDialogRoute extends SimplePageRoute {
  SimpleDialogRoute(String name, Widget widget) : super(name, widget);

  Route route(BuildContext context) {
    return PageRouteBuilder(
      opaque: false,
      settings: RouteSettings(name: name),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: Duration(milliseconds: 200),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      pageBuilder: (context, _, __) {
        return Scaffold(
          body: Center(child: builder(context)),
          backgroundColor: Colors.black.withOpacity(0.3),
        );
      },
    );
  }
}

Widget _routeNotFoundWidget(String name) => Scaffold(
      appBar: AppBar(), //To be able to go back
      body: Center(
        child: Text(
          "No route found for route $name",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
