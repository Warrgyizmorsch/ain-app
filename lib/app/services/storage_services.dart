import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/models/login_model/login_response_model.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find<StorageService>();

  late SharedPreferences _prefs;

  // Storage Keys
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  static const String _keyRememberMe = 'remember_me';
  static const String _themeKey = 'theme_mode';
  static const String _keyAccountsMap = 'saved_accounts_map';
  static const String _chatSessionKey = 'ain_chat_session';
  /// Initializes the SharedPreferences instance
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(_themeKey, mode);
  }

  String? getThemeMode() {
    return _prefs.getString(_themeKey);
  }
  Future<void> saveAccount(String email, String password) async {
    final Map<String, dynamic> currentAccounts = getSavedAccounts();
    currentAccounts[email.trim().toLowerCase()] = password;

    await _prefs.setString(_keyAccountsMap, jsonEncode(currentAccounts));
    await _prefs.setBool(_keyRememberMe, true);
  }

  /// Retrieves the map containing all stored login credentials
  Map<String, dynamic> getSavedAccounts() {
    final String? accountsJson = _prefs.getString(_keyAccountsMap);
    if (accountsJson == null || accountsJson.isEmpty) return {};
    try {
      return jsonDecode(accountsJson) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  /// Removes a single specific email account profile from the saved map list
  Future<void> removeAccount(String email) async {
    final Map<String, dynamic> currentAccounts = getSavedAccounts();
    currentAccounts.remove(email.trim().toLowerCase());

    await _prefs.setString(_keyAccountsMap, jsonEncode(currentAccounts));
    if (currentAccounts.isEmpty) {
      await _prefs.setBool(_keyRememberMe, false);
    }
  }

  /// Saves the master active status toggle for the remember me feature
  Future<void> saveRememberMeStatus(bool status) async {
    await _prefs.setBool(_keyRememberMe, status);
  }

  /// Checks if the master remember me option checkbox layer is active
  bool getRememberMeStatus() {
    return _prefs.getBool(_keyRememberMe) ?? false;
  }

  /// Purges all saved email account pairs and resets the remember status
  Future<void> clearSavedCredentials() async {
    await _prefs.remove(_keyAccountsMap);
    await _prefs.setBool(_keyRememberMe, false);
  }

  /// Fallback Method: Retrieves the first saved email from the map (for single auto-fill screens)
  String getSavedEmail() {
    final accounts = getSavedAccounts();
    return accounts.isNotEmpty ? accounts.keys.first : '';
  }

  /// Fallback Method: Retrieves the first saved password from the map
  String getSavedPassword() {
    final accounts = getSavedAccounts();
    return accounts.isNotEmpty ? accounts.values.first.toString() : '';
  }

  // ==========================================
  // AUTHENTICATION TOKEN MANAGEMENT
  // ==========================================

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  // ==========================================
  // USER PROFILE SCHEMAS MANAGEMENT
  // ==========================================

  UserData? getUser() {
    final userStr = _prefs.getString(_userKey);
    if (userStr != null) {
      return UserData.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  Future<void> saveUser(UserData user) async {
    await _prefs.setString(_userKey, jsonEncode(user));
  }
  String? getChatSession() {
    return _prefs.getString(_chatSessionKey);
  }

  Future<void> saveChatSession(String sessionId) async {
    await _prefs.setString(_chatSessionKey, sessionId);
  }

  Future<void> clearChatSession() async {
    await _prefs.remove(_chatSessionKey);
  }

  /// Clears active user tokens and metadata fields during manual session logs out
  Future<void> clearAuthData() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userKey);
  }
}