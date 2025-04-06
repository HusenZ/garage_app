import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../app/constants/color_manager.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    this.width,
    required this.text,
    this.style,
    this.tStyle,
    this.bPadding,
  });

  final dynamic Function()? onPressed;
  final ButtonStyle? style;
  final double? width;
  final TextStyle? tStyle;
  final String text;
  final EdgeInsets? bPadding;

  @override
  Widget build(BuildContext context) {
    // final double screenWidth = width ?? MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: () {
        onPressed?.call();
      },
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor: MaterialStateColor.resolveWith(
                (states) => ColorsManager.primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.w),
            ),
            elevation: 0,
            padding: bPadding,
          ),
      child: Text(
        text,
        style: tStyle ??
             TextStyle(fontSize: 16.sp,fontFamily: 'AppFonts', color: ColorsManager.whiteColor),
      ),
    );
  }
}
