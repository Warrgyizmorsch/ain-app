
import 'package:ain/app/common/constant/app_fonts_size.dart';
import 'package:ain/app/common/constant/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../constant/app_colors.dart';
import '../../constant/font_family.dart';

class TextFieldCustom extends StatelessWidget {
  Widget? suffixIcon;
  Widget? prefixIcon;
  Function()? onEditingComplete;
  Function()? onTap;
  int? maxLine;
  String? hintText;
  String? labelText;
  String? errorText;
  bool? obscureText;
  bool? readOnly;
  double? width;
  double? height;
  int? maxLines;
  int? maxLength;
  List<TextInputFormatter>? inputFormatters;
  String? fieldName;
  String? Function(String?)? validator;
  String? Function(String?)? onChanged;
  TextEditingController? controller;
  TextInputType? textInputType;
  TextInputAction? textInputAction;
  AutovalidateMode? autoValidateMode;
  Color? hintTextColor;
  String? hintTextStyle;
  double? hintTextSize;
  Color? borderColor;
  double? borderWidth;
  Color? backgroundColor;
  EdgeInsetsGeometry? contentPadding;
  bool? enabled;
  FocusNode? focusNode;
  Function(String)? onSubmitted;

  TextFieldCustom({
    super.key,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.labelText,
    this.onEditingComplete,
    this.onChanged,
    this.maxLine,
    this.hintText,
    this.errorText,
    this.obscureText,
    this.readOnly,
    this.maxLines,
    this.width,
    this.height,
    this.inputFormatters,
    this.fieldName,
    this.validator,
    this.textInputType,
    this.textInputAction,
    this.controller,
    this.maxLength,
    this.autoValidateMode,
    this.hintTextColor,
    this.hintTextStyle,
    this.hintTextSize,
    this.borderColor,
    this.borderWidth,
    this.backgroundColor,
    this.contentPadding,
    this.enabled,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        autovalidateMode: autoValidateMode,
        onTap: onTap,
        controller: controller,
        obscureText: obscureText ?? false,
        validator: validator,
        maxLines: (obscureText ?? false) ? 1 : maxLines,
        cursorColor: AppColors.primary,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        readOnly: readOnly ?? false,
        inputFormatters: inputFormatters ?? [],
        maxLength: maxLength,
        enabled: enabled ?? true,
        focusNode: focusNode,

        onFieldSubmitted: onSubmitted,
        style: TextStyle(
          fontSize: hintTextSize ?? 15,
          fontFamily: hintTextStyle ?? FontFamily.regular,
          color: AppColors.textPrimary,
        ),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hintText,
          labelText: labelText,
          errorText: errorText,
          labelStyle: TextStyle(
            color: hintTextColor ?? AppColors.textSecondary,
            fontSize: hintTextSize ?? AppFontSize.s14,
            fontFamily: hintTextStyle ?? FontFamily.regular,
          ),
          counterText: "",
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          errorStyle: AppTextStyles.error,
          hintStyle: TextStyle(
            color: hintTextColor ?? AppColors.textSecondary,
            fontSize: hintTextSize ?? AppFontSize.s14,
            fontFamily: hintTextStyle ?? FontFamily.regular,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.textSecondary,
              width: borderWidth ?? 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.textSecondary,
              width: borderWidth ?? 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color:  borderColor ?? AppColors.primary,
              width: borderWidth ?? 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.error,
              width: borderWidth ?? 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.error,
              width: borderWidth ?? 1.0,
            ),
          ),
          filled: true,
          fillColor: backgroundColor ?? Colors.white,
        ),
      ),
    );
  }
}