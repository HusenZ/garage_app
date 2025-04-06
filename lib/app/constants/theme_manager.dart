import 'package:flutter/material.dart';
import 'package:garage_app/app/constants/text_style_manager.dart';
import 'color_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: 'AppFonts',
    primaryColor: ColorsManager
        .primaryColor, // #FF5252 --> primary color #FF1744 ---> accent color  #FFCDD2 ---> background color #FFFFFF ---> font color
    primaryColorDark: ColorsManager.primaryColor,
    indicatorColor: ColorsManager.primaryColor,
    textTheme: TextTheme(
      bodyLarge: getExtraBold(
        color: ColorsManager.whiteColor,
      ),
      displayMedium: getSemiBoldStyle(
        color: ColorsManager.whiteColor,
      ),
      bodySmall: getLightStyle(
        color: ColorsManager.greyColor,
      ),
    ),
    colorScheme: const ColorScheme(
      background: ColorsManager.backgroundColor,
      brightness: Brightness.light,
      primary: ColorsManager.primaryColor,
      onPrimary: ColorsManager.primaryColor,
      onBackground: ColorsManager.backgroundColor,
      onSecondary: ColorsManager.accentColor,
      error: Colors.red,
      onError: Colors.redAccent,
      secondary: ColorsManager.accentColor,
      surface: Colors.white,
      onSurface: ColorsManager.blackColor,
    ),
  );
}
