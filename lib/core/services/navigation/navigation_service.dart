import 'package:flutter/material.dart';

abstract class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get context => navigatorKey.currentState!.context;

  static Future<T> navigateToPage<T>(Widget page) async {
    return await navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (context) => page));
  }

  static Future navigateToPageReplace(Widget page) async {
    await navigatorKey.currentState!
        .pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  static Future navigateToPageAndRemoveUntil(Widget page) async {
    await navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false);
  }

  static Future back<T extends Object?>({T? data, int times = 1}) async {
    for (int i = 0; i < times; i++) {
      await navigatorKey.currentState!.maybePop<T>(data);
    }
  }
}
