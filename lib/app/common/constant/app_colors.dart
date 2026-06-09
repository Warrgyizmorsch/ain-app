import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────────
  static const Color secondary   = Color(0xFF6C4EF6); // purple
  static const Color primary = Color(0xFF4E9AF6); // blue

  // ── Neutrals ─────────────────────────────────────────────────────────────────
  static const Color transparent = Colors.transparent;
  static const Color white       = Color(0xFFFFFFFF);
  static const Color black       = Color(0xFF000000);

  // ── Text ─────────────────────────────────────────────────────────────────────
  static const Color textPrimary       = Color(0xFF1A1D2E);
  static const Color textSecondary     = Color(0xFF8892A4);
  static const Color lightTextSecondary = Color(0xFF8892A4);
  static const Color lightTextHint     = Color(0xFFBDC3C7);
  static const Color lightTextDisabled = Color(0xFF95A5A6);

  // ── Borders & Dividers ───────────────────────────────────────────────────────
  static const Color lightDivider = Color(0xFFE2E6F0);

  // ── Surfaces ─────────────────────────────────────────────────────────────────
  static const Color background    = Color(0xFFF4F6FB);
  static const Color lightDisabled = Color(0xFFBDC3C7);
  static const Color lightShadow   = Color(0x1A000000);

  // ── Semantic ─────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);

  // ── Special UI ───────────────────────────────────────────────────────────────
  static const Color tagBg    = Color(0xFFEDE9FD); // step badge background
  static const Color tagText  = Color(0xFF5B3FD4); // step badge text
  static const Color priceBg  = Color(0xFFEEF6FF); // price box background
  static const Color priceDivider = Color(0xFFD6E6F7);

  // ── Gradients ────────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, secondary],
  );

  static const LinearGradient discountGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFF6B6B), Color(0xFFFF9A5C)],
  );
}