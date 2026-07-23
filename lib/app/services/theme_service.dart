import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ain/app/services/storage_services.dart';

class ThemeService extends GetxService with WidgetsBindingObserver {
  static ThemeService get to => Get.find<ThemeService>();

  /// Reactive ThemeMode value
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  /// Getters
  ThemeMode get themeMode => _themeMode.value;
  Rx<ThemeMode> get themeModeRx => _themeMode;

  /// Returns true if currently displaying dark mode UI.
  /// If themeMode is system, checks system platform brightness.
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  /// Backward-compatible RxBool for UI listeners checking dark mode boolean
  RxBool get isDarkModeRx => isDarkMode.obs;

  /// Current theme mode label for UI display
  String get themeModeName {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _loadTheme();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  /// Listen to system brightness changes when themeMode is ThemeMode.system
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (_themeMode.value == ThemeMode.system) {
      _themeMode.refresh();
      Get.forceAppUpdate();
      debugPrint('ThemeService: System platform brightness changed. UI refreshed.');
    }
  }

  Future<ThemeService> init() async {
    WidgetsBinding.instance.addObserver(this);
    await _loadTheme();
    return this;
  }

  /// Load theme setting from storage
  Future<void> _loadTheme() async {
    try {
      if (!Get.isRegistered<StorageService>()) {
        await Get.putAsync(() => StorageService().init());
      }

      final themeString = StorageService.to.getThemeMode();
      if (themeString == 'dark') {
        _themeMode.value = ThemeMode.dark;
      } else if (themeString == 'light') {
        _themeMode.value = ThemeMode.light;
      } else {
        _themeMode.value = ThemeMode.system;
      }

      Get.changeThemeMode(_themeMode.value);
      debugPrint('ThemeService: Loaded theme mode: ${themeString ?? "system"}');
    } catch (e) {
      debugPrint('ThemeService: Error loading theme: $e');
      _themeMode.value = ThemeMode.system;
    }
  }

  /// Set explicit ThemeMode (ThemeMode.light, ThemeMode.dark, ThemeMode.system)
  Future<void> updateThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _saveTheme(mode);
    _themeMode.refresh();
    Get.forceAppUpdate();
    debugPrint('ThemeService: Theme mode updated to: ${mode.name}');
  }

  /// Support setting by string ('system', 'light', 'dark')
  Future<void> setThemeModeByString(String modeString) async {
    ThemeMode mode;
    if (modeString == 'dark') {
      mode = ThemeMode.dark;
    } else if (modeString == 'light') {
      mode = ThemeMode.light;
    } else {
      mode = ThemeMode.system;
    }
    await updateThemeMode(mode);
  }

  /// Legacy boolean / dynamic setter support for backward compatibility
  Future<void> setThemeMode(dynamic value) async {
    if (value is ThemeMode) {
      await updateThemeMode(value);
    } else if (value is bool) {
      await updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    } else if (value is String) {
      await setThemeModeByString(value);
    }
  }

  /// Toggle between light and dark (if system, toggles based on current active state)
  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await updateThemeMode(newMode);
  }

  /// Persist theme selection
  Future<void> _saveTheme(ThemeMode mode) async {
    try {
      if (!Get.isRegistered<StorageService>()) {
        await Get.putAsync(() => StorageService().init());
      }
      String modeStr = 'system';
      if (mode == ThemeMode.dark) {
        modeStr = 'dark';
      } else if (mode == ThemeMode.light) {
        modeStr = 'light';
      }
      await StorageService.to.saveThemeMode(modeStr);
    } catch (e) {
      debugPrint('ThemeService: Error saving theme: $e');
    }
  }
}