import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garage_app/Views/welcome_screen.dart';
import 'package:garage_app/app/constants/color_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../app/constants/media_resources.dart';
import 'home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigation();
  }

  Future navigation() {
    return Future.delayed(const Duration(seconds: 2), () async {
      // final preferences = await SharedPreferences.getInstance();
      // final bool isAuthenticated =
      //     preferences.getBool('isAuthenticated') ?? false;
      // if (isAuthenticated) {
        // await MemberData.initializeGymId();
       Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
    //   } else {
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    //           (Route<dynamic> route) => false,
    //     );
    //   }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorsManager.whiteColor, // Set your desired color here
      statusBarBrightness:
      Brightness.light, // You can also set the brightness (dark or light)
    ));
    return Scaffold(
      backgroundColor: ColorsManager.greyColor,
      body: Center(
        child: Hero(
            tag: 'logo',
            child: Image.asset(
              MediaResources.logo,
              fit: BoxFit.fill
            )),
      ),
    );
  }
}
