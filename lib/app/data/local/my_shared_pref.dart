import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/translations/localization_service.dart';

class MySharedPref {
  // منع إنشاء instance
  MySharedPref._();

  // SharedPreferences instance
  static late SharedPreferences _sharedPreferences;

  // 🔑 Keys
  static const String _fcmTokenKey = 'fcm_token';
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _authTokenKey = 'auth_token';

  /// ✅ تهيئة SharedPreferences
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// تعيين instance يدويًا (اختياري)
  static void setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  // ---------------- 🌙 Theme ----------------
  static Future<void> setThemeIsLight(bool lightTheme) async =>
      await _sharedPreferences.setBool(_lightThemeKey, lightTheme);

  static bool getThemeIsLight() =>
      _sharedPreferences.getBool(_lightThemeKey) ?? true;

  // ---------------- 🌐 Language ----------------
  static Future<void> setCurrentLanguage(String languageCode) async =>
      await _sharedPreferences.setString(_currentLocalKey, languageCode);

  static Locale getCurrentLocal() {
    String? langCode = _sharedPreferences.getString(_currentLocalKey);
    return langCode != null
        ? LocalizationService.supportedLanguages[langCode]!
        : LocalizationService.defaultLanguage;
  }

  // ---------------- 🔔 FCM Token ----------------
  static Future<void> setFcmToken(String token) async =>
      await _sharedPreferences.setString(_fcmTokenKey, token);

  static String? getFcmToken() => _sharedPreferences.getString(_fcmTokenKey);

  // ---------------- 🔑 Auth Token ----------------
  static Future<void> setToken(String token) async =>
      await _sharedPreferences.setString(_authTokenKey, token);

  static Future<String?> getToken() async =>
      _sharedPreferences.getString(_authTokenKey);

  static Future<void> clearToken() async =>
      await _sharedPreferences.remove(_authTokenKey);

  static bool isLoggedIn() =>
      _sharedPreferences.containsKey(_authTokenKey) &&
      (_sharedPreferences.getString(_authTokenKey)?.isNotEmpty ?? false);

  // ---------------- 🧹 Clear All ----------------
  static Future<void> clear() async => await _sharedPreferences.clear();
}
