import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garage_app/Views/splash_screen.dart';
import 'package:sizer/sizer.dart';

import 'constants/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static MyApp instance = const MyApp._internal();

  @override
  State<MyApp> createState() => _MyAppState();

  factory MyApp() => instance;
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Set your desired color here
      statusBarBrightness:
      Brightness.light, // You can also set the brightness (dark or light)
    ));

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          theme: getApplicationTheme(),
        );
      },
    );
  }
}
