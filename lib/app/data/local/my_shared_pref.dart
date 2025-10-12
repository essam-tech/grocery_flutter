import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/translations/localization_service.dart';
import '../models/CustomerAddress .dart';

class MySharedPref {
  MySharedPref._();

  static late SharedPreferences _sharedPreferences;

  // 🔑 المفاتيح
  static const String _fcmTokenKey = 'fcm_token';
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _authTokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userPhoneKey = 'user_phone';
  static const String _addressesKey = 'user_addresses';

  /// تهيئة SharedPreferences
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
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
  static Future<void> setToken(String token) async {
    if (token.isEmpty) return;
    await _sharedPreferences.setString(_authTokenKey, token);
    debugPrint("✅ تم حفظ التوكن محليًا");
  }

  static String? getToken() {
    final token = _sharedPreferences.getString(_authTokenKey);
    if (token == null || token.isEmpty) {
      debugPrint("⚠️ لا يوجد توكن محفوظ");
      return null;
    }
    return token;
  }

  static Future<void> clearToken() async {
    await _sharedPreferences.remove(_authTokenKey);
    debugPrint("🧹 تم مسح التوكن من الجهاز");
  }

  static bool isLoggedIn() =>
      _sharedPreferences.containsKey(_authTokenKey) &&
      (_sharedPreferences.getString(_authTokenKey)?.isNotEmpty ?? false);

  // ---------------- 👤 User Info ----------------
  static Future<void> setUserId(int id) async =>
      await _sharedPreferences.setInt(_userIdKey, id);

  static int? getUserId() => _sharedPreferences.getInt(_userIdKey);

  static Future<void> setPhone(String phone) async =>
      await _sharedPreferences.setString(_userPhoneKey, phone);

  static String? getPhone() => _sharedPreferences.getString(_userPhoneKey);

  // ---------------- 🏠 Addresses ----------------
  static Future<void> setAddresses(List<CustomerAddress> addresses) async {
    List<String> jsonList =
        addresses.map((a) => jsonEncode(a.toJson())).toList();
    await _sharedPreferences.setStringList(_addressesKey, jsonList);
  }

  static List<CustomerAddress> getAddresses() {
    List<String> jsonList =
        _sharedPreferences.getStringList(_addressesKey) ?? [];
    return jsonList
        .map((e) => CustomerAddress.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<void> addAddress(CustomerAddress newAddress) async {
    List<CustomerAddress> currentAddresses = getAddresses();
    currentAddresses.add(newAddress);
    await setAddresses(currentAddresses);
  }

  static Future<void> removeAddress(CustomerAddress address) async {
    List<CustomerAddress> currentAddresses = getAddresses();
    currentAddresses.removeWhere(
        (a) => a.publicId == address.publicId); // ✅ تم التصحيح هنا
    await setAddresses(currentAddresses);
  }

  // ---------------- 🧹 Clear All ----------------
  static Future<void> clear() async {
    await _sharedPreferences.clear();
    debugPrint("🧹 تم مسح جميع البيانات من SharedPreferences");
  }
}
