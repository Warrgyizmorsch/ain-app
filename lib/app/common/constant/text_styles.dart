import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts_size.dart';
import 'font_family.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display ──────────────────────────────────────────────────────────────────
  static TextStyle get displayLarge => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Headings ─────────────────────────────────────────────────────────────────
  static TextStyle get h1 => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get h2 => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get headline => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get subhead => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Title ────────────────────────────────────────────────────────────────────
  static TextStyle get titleLarge => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// AppBar title — "Order Assignment" / "Order Now"
  static TextStyle get appBarTitle => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Section ──────────────────────────────────────────────────────────────────
  /// Bold gradient heading — "Assignment Details"
  static TextStyle get sectionHeading => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Subtext below section heading
  static TextStyle get sectionSub => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ── Field ────────────────────────────────────────────────────────────────────
  /// Uppercase field label — "ASSIGNMENT TOPIC", "SUBJECT" etc.
  static TextStyle get fieldLabel => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.6,
  );

  /// Input typed text
  static TextStyle get inputText => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  /// Input / dropdown hint
  static TextStyle get hintText => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Dropdown item text
  static TextStyle get dropdownItem => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // ── Body ─────────────────────────────────────────────────────────────────────
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get subtitle => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // ── Step Badge ───────────────────────────────────────────────────────────────
  /// Text inside the step pill — "Step 1/2"
  static TextStyle get stepBadge => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s11,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF5B3FD4),
    letterSpacing: 0.3,
  );

  // ── Price Box ────────────────────────────────────────────────────────────────
  /// "Price Details" title
  static TextStyle get priceTitle => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s11,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );

  /// Row label — "Basic Price (USD)", "Discount"
  static TextStyle get priceLabel => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Row value — "USD 224.52"
  static TextStyle get priceValue => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Discount value — "USD 67.36" in red
  static TextStyle get discountValue => TextStyle(
    fontFamily: FontFamily.semiBold,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  /// Total label
  static TextStyle get totalLabel => TextStyle(
    fontFamily: FontFamily.bold,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Total value — "USD 157.16" in primary
  static TextStyle get totalValue => TextStyle(
    fontFamily: FontFamily.bold,
    fontSize: AppFontSize.s15,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  // ── Upload zone ──────────────────────────────────────────────────────────────
  /// "Drop files here or click to upload"
  static TextStyle get uploadHint => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ── Terms ────────────────────────────────────────────────────────────────────
  /// Terms & conditions body text
  static TextStyle get termsText => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Terms links — "Terms of Use", "Privacy Policy", "Money Back Guarantee"
  static TextStyle get termsLink => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s10,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    height: 1.5,
  );

  // ── Button ───────────────────────────────────────────────────────────────────
  static TextStyle get button => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s15,
    fontWeight: FontWeight.w600,
    color: AppColors.white, // Made this dynamic too if needed
  );

  // ── Misc ─────────────────────────────────────────────────────────────────────
  static TextStyle get caption => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get overline => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get error => TextStyle(
    fontSize: AppFontSize.s12,
    fontFamily: FontFamily.regular,
    color: AppColors.error,
  );

  // ── Wallet ─────────────────────────────────────────────────────────────────
  static TextStyle get walletTitle => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get walletAmountLabel => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get walletAmount => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s28,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static TextStyle get transactionTitle => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get transactionAmount => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s14,
    fontWeight: FontWeight.w600,
    color: Colors.green, // You can also move this to AppColors.success
  );

  static TextStyle get transactionHistory => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get noTransaction => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s12,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
}