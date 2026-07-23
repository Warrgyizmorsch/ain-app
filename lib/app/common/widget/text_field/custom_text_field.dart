
import 'package:ain/app/common/constant/app_fonts_size.dart';
import 'package:ain/app/common/constant/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../constant/app_colors.dart';
import '../../constant/font_family.dart';

class TextFieldCustom extends StatelessWidget {
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final int? maxLine;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool? obscureText;
  final bool? readOnly;
  final double? width;
  final double? height;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? fieldName;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autoValidateMode;
  final Color? hintTextColor;
  final String? hintTextStyle;
  final double? hintTextSize;
  final Color? borderColor;
  final double? borderWidth;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool? enabled;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;

  const TextFieldCustom({
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
    // Determine the baseline border color to use dynamically according to active theme
    final currentBorderColor = borderColor ?? AppColors.lightDivider;
    final fallbackFocusColor = borderColor ?? AppColors.primary;
    final currentFillColor = backgroundColor ?? AppColors.bgLight;

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
            color: hintTextColor ?? AppColors.lightTextHint,
            fontSize: hintTextSize ?? AppFontSize.s14,
            fontFamily: hintTextStyle ?? FontFamily.regular,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: currentBorderColor, width: borderWidth ?? 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: currentBorderColor, width: borderWidth ?? 1.0),
          ),
          // If a custom error/border color is forced, use it for focus state to suppress the primary focus color
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: fallbackFocusColor, width: borderWidth ?? 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.error, width: borderWidth ?? 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.error, width: borderWidth ?? 1.5),
          ),
          filled: true,
          fillColor: currentFillColor,
        ),
      ),
    );
  }
}