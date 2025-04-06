import 'package:flutter/material.dart';
import '../../Views/splash_screen.dart';
import '../../Views/welcome_screen.dart';

class Routes {
  static const String splashRoute = '/';
  static const String welcomeRoute = '/welcomePage';
}

Map<String, WidgetBuilder> get routes {
  return <String, WidgetBuilder>{
    Routes.splashRoute: (context) {
      return const SplashScreen();
    },
    Routes.welcomeRoute: (context) => WelcomeScreen(),

  };
}
