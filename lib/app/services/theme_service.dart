import 'package:ain/app/services/storage_services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  /// Reactive variable to track dark mode
  final RxBool _isDarkMode = false.obs;

  /// Current theme state
  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  /// Reactive stream for UI listening
  RxBool get isDarkModeRx => _isDarkMode;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }
  Future<ThemeService> init() async {
    await _loadTheme();
    return this;
  }
  /// Load theme from storage
  Future<void> _loadTheme() async {
    try {
      if (!Get.isRegistered<StorageService>()) {
        await Get.putAsync(() => StorageService().init());
      }

      final themeString = StorageService.to.getThemeMode();
      _isDarkMode.value = themeString == 'dark';
      debugPrint('ThemeService: Theme loaded: ${_isDarkMode.value ? "dark" : "light"}');
    } catch (e) {
      debugPrint('ThemeService: Error loading theme: $e');
      _isDarkMode.value = false; // fallback
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );

    await _saveTheme();
    debugPrint('ThemeService: Theme toggled to: ${_isDarkMode.value ? "dark" : "light"}');
  }

  /// Explicitly set theme mode
  Future<void> setThemeMode(bool isDark) async {
    _isDarkMode.value = isDark;
    Get.changeThemeMode(
      isDark ? ThemeMode.dark : ThemeMode.light,
    );
    await _saveTheme();
    debugPrint('ThemeService: Theme set to: ${isDark ? "dark" : "light"}');
  }

  /// Persist theme selection
  Future<void> _saveTheme() async {
    try {
      if (!Get.isRegistered<StorageService>()) {
        await Get.putAsync(() => StorageService().init());
      }
      await StorageService.to.saveThemeMode(_isDarkMode.value ? 'dark' : 'light');
    } catch (e) {
      debugPrint('ThemeService: Error saving theme: $e');
    }
  }
}