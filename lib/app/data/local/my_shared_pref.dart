import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/translations/localization_service.dart';

class MySharedPref {
  // prevent making instance
  MySharedPref._();

  // get storage
  static late SharedPreferences _sharedPreferences;

  // STORING KEYS
  static const String _fcmTokenKey = 'fcm_token';
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';

  // ✅ مفتاح التوكن
  static const String _authTokenKey = 'auth_token';

  /// init shared preference
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// ---------------- 🌙 Theme ----------------
  static Future<void> setThemeIsLight(bool lightTheme) =>
      _sharedPreferences.setBool(_lightThemeKey, lightTheme);

  static bool getThemeIsLight() =>
      _sharedPreferences.getBool(_lightThemeKey) ?? true;

  /// ---------------- 🌐 Language ----------------
  static Future<void> setCurrentLanguage(String languageCode) =>
      _sharedPreferences.setString(_currentLocalKey, languageCode);

  static Locale getCurrentLocal() {
    String? langCode = _sharedPreferences.getString(_currentLocalKey);
    // default language is english
    if (langCode == null) {
      return LocalizationService.defaultLanguage;
    }
    return LocalizationService.supportedLanguages[langCode]!;
  }

  /// ---------------- 🔔 FCM Token ----------------
  static Future<void> setFcmToken(String token) =>
      _sharedPreferences.setString(_fcmTokenKey, token);

  static String? getFcmToken() =>
      _sharedPreferences.getString(_fcmTokenKey);

  /// ---------------- 🔑 Auth Token ----------------
  static Future<void> setToken(String token) async =>
      await _sharedPreferences.setString(_authTokenKey, token);

  static String? getToken() =>
      _sharedPreferences.getString(_authTokenKey);

  static Future<void> clearToken() async =>
      await _sharedPreferences.remove(_authTokenKey);

  static bool isLoggedIn() =>
      _sharedPreferences.containsKey(_authTokenKey) &&
      (_sharedPreferences.getString(_authTokenKey)?.isNotEmpty ?? false);

  /// ---------------- 🧹 Clear All ----------------
  static Future<void> clear() async => await _sharedPreferences.clear();
}
