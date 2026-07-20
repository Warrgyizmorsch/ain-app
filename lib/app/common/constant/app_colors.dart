import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/theme_service.dart';

// Make sure to import your ThemeService here
// import 'path/to/your/theme_service.dart';

class AppColors {
  AppColors._();

  // ── Theme Checker ──────────────────────────────────────────────────────────
  static bool get _isDarkMode {
    if (Get.isRegistered<ThemeService>()) {
      return ThemeService.to.isDarkMode;
    }
    return false;
  }

  // ── Absolute Colors (Never change based on theme) ──────────────────────────
  static const Color transparent = Colors.transparent;
  static const Color white       = Color(0xFFFFFFFF);
  static const Color white70     = Colors.white70;
  static const Color black       = Color(0xFF000000);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);

  // ── Primary and Secondary ──────────────────────────────────────────────────
  static Color get primary   => _isDarkMode ? const Color(0xFF6A1B9A) : const Color(0xFF4A148C);
  static Color get secondary => _isDarkMode ? const Color(0xFF9C27B0) : const Color(0xFF7B1FA2);
  static Color get primaryPurple => _isDarkMode ? const Color(0xFF7E57C2) : const Color(0xFF5E35B1);

  // ── Text Colors ────────────────────────────────────────────────────────────
  static Color get textPrimary       => _isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF1A1D2E);
  static Color get textSecondary     => _isDarkMode ? const Color(0xFFAAB4C3) : const Color(0xFF8892A4);
  static Color get lightTextSecondary => _isDarkMode ? const Color(0xFFAAB4C3) : const Color(0xFF8892A4);
  static Color get lightTextHint     => _isDarkMode ? const Color(0xFF5B626A) : const Color(0xFFBDC3C7);
  static Color get lightTextDisabled => _isDarkMode ? const Color(0xFF4A5556) : const Color(0xFF95A5A6);
  static Color get textDark          => _isDarkMode ? const Color(0xFFF5F5F5) : const Color(0xFF1E1E1E);
  static Color get textGrey          => _isDarkMode ? const Color(0xFFB4B4B8) : const Color(0xFF8E8E93);

  // ── Status Colors ──────────────────────────────────────────────────────────
  static Color get statusOrange => _isDarkMode ? const Color(0xFFFFAB91) : const Color(0xFFFF8A65);
  static Color get statusGreen  => _isDarkMode ? const Color(0xFF81C784) : const Color(0xFF4CAF50);
  static Color get statusPurple => _isDarkMode ? const Color(0xFF9575CD) : const Color(0xFF5E35B1);
  static Color get statusGrey   => _isDarkMode ? const Color(0xFFBDBDBD) : const Color(0xFF9E9E9E);

  // ── Borders & Dividers ─────────────────────────────────────────────────────
  static Color get lightDivider => _isDarkMode ? const Color(0xFF2D3243) : const Color(0xFFE2E6F0);
  static Color get sectionTitleBorder => _isDarkMode ? const Color(0xFF7E57C2) : const Color(0xFF5E2CED);

  // ── Surfaces & Backgrounds ─────────────────────────────────────────────────
  static Color get background    => _isDarkMode ? const Color(0xFF121212) : const Color(0xFFEDE7F6);
  static Color get appBackground => _isDarkMode ? const Color(0xFF1A1A24) : const Color(0xFFF6F5F5);
  static Color get bgLight       => _isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA);
  static Color get lightDisabled => _isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFBDC3C7);
  static Color get lightShadow   => _isDarkMode ? const Color(0x33000000) : const Color(0x1A000000);

  // ── Buttons & Tailwind Custom Shutter Colors ───────────────────────────────
  static Color get buttonPrimary => _isDarkMode ? const Color(0xFF6542D0) : const Color(0xFF3F159A);

  static Color get shutterPrimaryBg => _isDarkMode ? const Color(0xFF6542D0) : const Color(0xFF3F159A);
  static Color get shutterPrimaryHover => _isDarkMode ? const Color(0xFF2A1B40) : const Color(0xFFFBF2FE);
  static Color get shutterPrimaryTextHover => _isDarkMode ? const Color(0xFFF5F5F5) : const Color(0xFF222222);

  static Color get shutterSecondaryBg => _isDarkMode ? const Color(0xFFFB923C) : const Color(0xFFF97316);
  static Color get shutterOrange => _isDarkMode ? const Color(0xFFFF8A65) : const Color(0xFFFF5722);
  static Color get shutterBlue   => _isDarkMode ? const Color(0xFF6542D0) : const Color(0xFF3F159A);

  // ── Tailwind Hero Background & Shapes ──────────────────────────────────────
  static Color get heroBgStart  => _isDarkMode ? const Color(0xFF1E1E2C) : const Color(0xFFEEF2FF);
  static Color get heroBgMiddle => _isDarkMode ? const Color(0xFF231E35) : const Color(0xFFF7F3FF);
  static Color get heroBgEnd    => _isDarkMode ? const Color(0xFF2C1C24) : const Color(0xFFFFF5F8);

  static Color get heroShape1 => _isDarkMode
      ? const Color(0xFF6366F1).withValues(alpha: 0.25)
      : const Color(0xFF6366F1).withValues(alpha: 0.45);

  static Color get heroShape2 => _isDarkMode
      ? const Color(0xFFEC4899).withValues(alpha: 0.20)
      : const Color(0xFFEC4899).withValues(alpha: 0.35);

  static Color get heroShape3 => _isDarkMode
      ? const Color(0xFF4F46E5).withValues(alpha: 0.15)
      : const Color(0xFF4F46E5).withValues(alpha: 0.30);

  // ── Special UI ─────────────────────────────────────────────────────────────
  static Color get tagBg    => _isDarkMode ? const Color(0xFF2D2454) : const Color(0xFFEDE9FD);
  static Color get tagText  => _isDarkMode ? const Color(0xFFB4A2FF) : const Color(0xFF5B3FD4);
  static Color get priceBg  => _isDarkMode ? const Color(0xFF1A2639) : const Color(0xFFEEF6FF);
  static Color get priceDivider => _isDarkMode ? const Color(0xFF2C3E50) : const Color(0xFFD6E6F7);

  // ── Gradients ──────────────────────────────────────────────────────────────
  // Because the primary/secondary colors are getters, these gradients MUST also be getters
  static LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, secondary], // Automatically updates based on theme
  );

  static LinearGradient get discountGradient => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: _isDarkMode
        ? const [Color(0xFFD32F2F), Color(0xFFE64A19)]
        : const [Color(0xFFFF6B6B), Color(0xFFFF9A5C)],
  );

  static LinearGradient get heroBackgroundGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0.0, 0.42, 1.0],
    colors: [heroBgStart, heroBgMiddle, heroBgEnd],
  );
}