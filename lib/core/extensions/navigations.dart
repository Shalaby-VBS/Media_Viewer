import 'package:flutter/material.dart';

extension Navigations on BuildContext {
  bool get canPop => ModalRoute.of(this)!.canPop;

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T?>(routeName, arguments: arguments);
  }

  Future<T?> popAndPushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).popAndPushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(
      result,
    );
  }

  Object? get argument => ModalRoute.of(this)?.settings.arguments;
}
