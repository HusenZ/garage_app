import 'package:flutter/material.dart';
import 'package:garage_app/app/constants/text_style_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: 'AppFonts',
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyLarge: getExtraBold(
        color: Colors.white
      ),
      displayMedium: getSemiBoldStyle(
        color: Colors.white
      ),
      bodySmall: getLightStyle(
        color: Colors.white
      ),
    ),
  
  );
}
