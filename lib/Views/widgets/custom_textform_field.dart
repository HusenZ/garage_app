import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../app/constants/color_manager.dart';
import '../../app/constants/fonts_manager.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.label,
    this.fontSize,
    this.keyboardType,
    this.hintStyle,
    this.hintText,
    this.prefixText,
    this.validator,
    required this.readOnly,
    required this.autoFocus,
    required this.obscureText,
    required this.enable,
    this.inputFormatters,
    this.initialValue,
    this.onPressed,
    this.suffixIcon,
    this.textAlign,
  });

  final TextEditingController controller;
  final String? label;
  final String? initialValue;
  final String? hintText;
  final String? prefixText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool autoFocus;
  final bool obscureText;
  final bool enable;
  final FormFieldValidator? validator;
  final double? fontSize;
  final TextStyle? hintStyle;
  final Function()? onPressed;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleY: 0.23.w,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            2.w,
          ),
          color: ColorsManager.whiteColor,
          boxShadow: [
            !enable
                ? BoxShadow(
                    color: ColorsManager.greyColor.withOpacity(0.25),
                    blurRadius: 3,
                    spreadRadius: 0.0,
                    offset: Offset(1, 2),
                  )
                : const BoxShadow(
                    color: ColorsManager.blackColor,
                  ),
          ],
        ),
        child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            textAlignVertical: TextAlignVertical.center,
            onTap: onPressed,
            textAlign: textAlign ?? TextAlign.start,
            cursorColor: ColorsManager.primaryColor,
            obscureText: obscureText,
            initialValue: initialValue,
            controller: controller,
            validator: validator,
            autofocus: autoFocus,
            readOnly: readOnly,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            // textAlign: TextAlign.center,
            // textAlignVertical: TextAlignVertical.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: fontSize,
                ),
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              labelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'AppFonts',
                  fontWeight: FontWeightManager.normal,
                  color: ColorsManager.hintTextColor),
              prefixText: prefixText,
              labelText: label,
              hintText: hintText,
              hintStyle: hintStyle,
              enabled: enable,
              disabledBorder: InputBorder.none,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorsManager.blackColor),
                  borderRadius: BorderRadius.all(Radius.circular(3.w))),
              floatingLabelStyle: const TextStyle(
                color: ColorsManager.primaryColor,
                fontFamily: 'AppFonts',
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:  BorderSide(
                  color: ColorsManager.greyColor.withOpacity(0.5), // Non-selected border color
                ),
                borderRadius:
                    BorderRadius.circular(3.w), // Adjust the radius as needed
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: ColorsManager.primaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(3.w)),
              ),
            )),
      ),
    );
  }
}
