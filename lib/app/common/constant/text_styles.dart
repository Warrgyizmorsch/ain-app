import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts_size.dart';
import 'font_family.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display ──────────────────────────────────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // ── Headings ─────────────────────────────────────────────────────────────────
  static final TextStyle h1 = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle subhead = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Title ────────────────────────────────────────────────────────────────────
  static const TextStyle titleLarge = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// AppBar title — "Order Assignment" / "Order Now"
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: FontFamily.semiBold,
    fontSize: AppFontSize.s15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Section ──────────────────────────────────────────────────────────────────
  /// Bold gradient heading — "Assignment Details"
  static const TextStyle sectionHeading = TextStyle(
    fontFamily: FontFamily.bold,
    fontSize: AppFontSize.s18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Subtext below section heading
  static const TextStyle sectionSub = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ── Field ────────────────────────────────────────────────────────────────────
  /// Uppercase field label — "ASSIGNMENT TOPIC", "SUBJECT" etc.
  static const TextStyle fieldLabel = TextStyle(
    fontFamily: FontFamily.semiBold,
    fontSize: AppFontSize.s11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.6,
  );

  /// Input typed text
  static const TextStyle inputText = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  /// Input / dropdown hint
  static const TextStyle hintText = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Dropdown item text
  static const TextStyle dropdownItem = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // ── Body ─────────────────────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // ── Step Badge ───────────────────────────────────────────────────────────────
  /// Text inside the step pill — "Step 1/2"
  static const TextStyle stepBadge = TextStyle(
    fontFamily: FontFamily.semiBold,
    fontSize: AppFontSize.s11,
    fontWeight: FontWeight.w600,
    color: Color(0xFF5B3FD4),
    letterSpacing: 0.3,
  );

  // ── Price Box ────────────────────────────────────────────────────────────────
  /// "Price Details" title
  static const TextStyle priceTitle = TextStyle(
    fontFamily: FontFamily.bold,
    fontSize: AppFontSize.s11,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );

  /// Row label — "Basic Price (USD)", "Discount"
  static const TextStyle priceLabel = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Row value — "USD 224.52"
  static const TextStyle priceValue = TextStyle(
    fontFamily: FontFamily.semiBold,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Discount value — "USD 67.36" in red
  static const TextStyle discountValue = TextStyle(
    fontFamily: FontFamily.semiBold,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  /// Total label
  static const TextStyle totalLabel = TextStyle(
    fontFamily: FontFamily.bold,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Total value — "USD 157.16" in primary
  static const TextStyle totalValue = TextStyle(
    fontFamily: FontFamily.bold,
    fontSize: AppFontSize.s15,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  // ── Upload zone ──────────────────────────────────────────────────────────────
  /// "Drop files here or click to upload"
  static const TextStyle uploadHint = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ── Terms ────────────────────────────────────────────────────────────────────
  /// Terms & conditions body text
  static const TextStyle termsText = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Terms links — "Terms of Use", "Privacy Policy", "Money Back Guarantee"
  static const TextStyle termsLink = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s10,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    height: 1.5,
  );

  // ── Button ───────────────────────────────────────────────────────────────────
  static const TextStyle button = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // ── Misc ─────────────────────────────────────────────────────────────────────
  static const TextStyle caption = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s10,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle error = TextStyle(
    fontSize: AppFontSize.s12,
    fontFamily: FontFamily.regular,
    color: AppColors.error,
  );
  // ── Wallet ─────────────────────────────────────────────────────────────────

  static const TextStyle walletTitle = TextStyle(
    fontFamily: FontFamily.semiBold,
    fontSize: AppFontSize.s18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle walletAmountLabel = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle walletAmount = TextStyle(
    fontFamily: FontFamily.bold,
    fontSize: AppFontSize.s28,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle transactionTitle = TextStyle(
    fontFamily: FontFamily.semiBold,
    fontSize: AppFontSize.s14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle transactionAmount = TextStyle(
    fontFamily: FontFamily.bold,
    fontSize: AppFontSize.s14,
    fontWeight: FontWeight.w700,
    color: Colors.green,
  );

  static const TextStyle transactionHistory = TextStyle(
    fontFamily: FontFamily.semiBold,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle noTransaction = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: FontFamily.regular,
    fontSize: AppFontSize.s12,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
}