library apn_router;

import 'package:apn_router/sheet_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Pilot {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void pop<T>([T result]) => navigatorKey.currentState.pop<T>(result);

  static void popToRoot() => navigatorKey.currentState.popUntil((route) => route.isFirst);

  static Future<T> showModal<T>(BuildContext context, ModalPageRoute route, {bool enableDrag = true}) {
    return route.show<T>(context, enableDrag: enableDrag);
  }

  static Future<T> nav<T>(PageRoute route) => navigatorKey.currentState.pushNamed<T>(
        route.name,
        arguments: route,
      );

  static Route<T> generateRoute<T>(RouteSettings settings) {
    final currentContext = navigatorKey.currentContext;

    if (settings.arguments is PageRoute) {
      return (settings.arguments as PageRoute).route(currentContext);
    } else {
      return _routeNotFound(settings.name);
    }
  }

  static Route<dynamic> _routeNotFound(String name) => MaterialPageRoute(builder: (_) => _routeNotFoundWidget(name));
}

abstract class PageRoute<T> {
  String get name => "/";

  Widget builder(BuildContext context);

  Route<T> route(BuildContext context) => MaterialPageRoute<T>(
        builder: builder,
        settings: RouteSettings(name: name),
      );
}

class SimplePageRoute<T> extends PageRoute<T> {
  final String name;
  final Widget widget;

  SimplePageRoute(this.name, this.widget);

  @override
  Widget builder(BuildContext context) => widget;
}

class SimpleDialogRoute<T> extends SimplePageRoute<T> {
  SimpleDialogRoute(String name, Widget widget) : super(name, widget);

  Route<T> route(BuildContext context) {
    return PageRouteBuilder<T>(
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

class ModalPageRoute<T> {
  final String name;
  final Widget widget;
  final Widget header;

  ModalPageRoute(
    this.name,
    this.widget, {
    this.header,
  });


  Future<T> show<T>(BuildContext context, {bool enableDrag = true}) {
    return showSheetModal<T>(
      context,
      child: header != null ? widget : null,
      modal: widget,
      header: header,
      enableDrag: enableDrag,
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
