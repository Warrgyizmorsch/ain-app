import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  // Enables the `StorageService.to.methodName()` syntax used in ApiClient
  static StorageService get to => Get.find<StorageService>();

  late SharedPreferences _prefs;

  // Storage Keys
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  // Initialize the service (Call this in main.dart)
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ==========================================
  // TOKEN MANAGEMENT
  // ==========================================

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  // ==========================================
  // REFRESH TOKEN MANAGEMENT
  // ==========================================

  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  // ==========================================
  // USER DATA MANAGEMENT
  // ==========================================

  Map<String, dynamic>? getUser() {
    final userStr = _prefs.getString(_userKey);
    if (userStr != null) {
      return jsonDecode(userStr);
    }
    return null;
  }

  Future<void> saveUser(dynamic user) async {
    // Converts the user object/map into a JSON string before saving
    await _prefs.setString(_userKey, jsonEncode(user));
  }

  // ==========================================
  // CLEAR DATA (LOGOUT)
  // ==========================================

  Future<void> clearAuthData() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userKey);
  }
}