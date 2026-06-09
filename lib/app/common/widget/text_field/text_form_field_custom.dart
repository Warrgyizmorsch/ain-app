

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constant/app_colors.dart';
import '../../constant/font_family.dart';


class TextFormFieldCustom extends StatelessWidget {
  final Widget method;
  final String title;
  final bool? isRequired;
  final Color? hintTextColor;
  final String? hintTextStyle;
  final double? hintTextSize;
  final double? borderWidth;
  final double? height;
  final Color? borderColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool showTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const TextFormFieldCustom({
    super.key,
    required this.method,
    this.title = "",
    this.isRequired,
    this.hintTextStyle,
    this.hintTextSize,
    this.hintTextColor,
    this.borderColor,
    this.height,
    this.borderWidth,
    this.backgroundColor,
    this.padding,
    this.showTitle = true,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (showTitle && title.isNotEmpty)
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: hintTextSize ?? 14,
                    color: hintTextColor ?? AppColors.textPrimary,
                    fontFamily: hintTextStyle ?? FontFamily.regular,
                  ),
                ).paddingOnly(left: 5, bottom: 5),
                isRequired==true?
                Text(
                  "*",
                  style: TextStyle(
                    fontSize: hintTextSize ?? 14,
                    color:  AppColors.error,
                    fontFamily: FontFamily.regular,
                  ),
                ).paddingOnly(left: 5, ):SizedBox.shrink(),
              ],
            ),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor ?? AppColors.transparent,
                width: borderWidth ?? 1.0,
              ),
            ),
            child: method,
          ),
        ],
      ),
    );
  }
}
class UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = "";

    if (digits.length <= 3) {
      formatted = digits;
    } else if (digits.length <= 6) {
      formatted = "(${digits.substring(0, 3)}) ${digits.substring(3)}";
    } else if (digits.length <= 10) {
      formatted =
      "(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}";
    } else {
      formatted =
      "(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6, 10)}";
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
