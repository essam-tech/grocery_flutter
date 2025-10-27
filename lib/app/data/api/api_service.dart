import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:grocery_app/app/data/local/my_shared_pref.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/product_section_model.dart';
import '../models/cart_model.dart';
import '../models/ProfileModel.dart';
import '../models/CustomerAddress .dart';

class ApiService {
  // ===================== روابط API الأساسية =====================
  static const String productBaseUrl =
      "https://maqadhi.com:56976/api/v2/store/product";
  static const String authBaseUrl =
      "https://maqadhi.com:56976/api/v2/store/email-verification";
  static const String customerBaseUrl =
      "https://maqadhi.com:56976/api/v2/store/customer";
  static const String cartBaseUrl =
      "https://maqadhi.com:56976/api/v2/store/cart";
  static const String addressBaseUrl =
      "https://maqadhi.com:56976/api/v2/store/customer-address";

  // ===================== الهيدرز الثابتة =====================
  static const Map<String, String> headers = {
    'Store-Domain': 'essam2',
    'Content-Type': 'application/json',
  };

  static Map<String, String> authHeaders({String? token}) {
    final map = {
      'Content-Type': 'application/json',
      'Store-Domain': 'essam2',
    };
    if (token != null && token.isNotEmpty) {
      map['Authorization'] = 'Bearer $token';
    }
    return map;
  }

  // ===================== أدوات التحقق من التوكن =====================
  static void checkToken(String? token) {
    if (token == null || token.isEmpty) {
      throw Exception("⚠️ توكن غير صالح أو فارغ");
    }
  }

  /// ⚠️ التحقق من انتهاء التوكن بدون مسحه
  static Future<bool> _checkIfTokenExpired(http.Response response) async {
    if (response.statusCode == 401 ||
        response.body.contains("Token expired") ||
        response.body.contains("token expired")) {
      debugPrint("🚨 Token expired حسب السيرفر - يحتاج إعادة تسجيل دخول");
      await MySharedPref.clearToken();
      return true;
    }
    return false;
  }

  // ===================== التجديد التلقائي للتوكن =====================
 static Future<bool> _refreshTokenIfNeeded() async {
  final token = MySharedPref.getToken();
  if (token != null && !MySharedPref.isTokenExpired()) return true;

  final refreshToken = MySharedPref.getRefreshToken();
  final customerId = MySharedPref.getUserId()?.toString() ?? '';

  if (refreshToken == null || refreshToken.isEmpty || customerId.isEmpty) return false;

  try {
    final url = Uri.parse("$authBaseUrl/refresh");
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'Store-Domain': 'essam2'},
        body: json.encode({
          "customerId": customerId,
          "refreshToken": refreshToken,
          "userAgent": "FlutterApp/1.0.0 (Android)"
        }));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body)['data'];
      final newToken = data['accessToken'];
      final expireTime = DateTime.parse(data['expireTime']);
      await MySharedPref.setToken(newToken,
          expiresIn: expireTime.difference(DateTime.now()),
          refreshToken: data['refreshToken']);
      debugPrint("✅ تم تجديد التوكن تلقائيًا");
      return true;
    }
  } catch (e) {
    debugPrint("🚨 فشل تجديد التوكن: $e");
  }

  await MySharedPref.clearToken();
  return false;
}


  static Future<http.Response> getWithAuth(String url) async {
    final ok = await _refreshTokenIfNeeded();
    if (!ok) throw Exception("Token expired - تسجيل دخول مطلوب");

    final token = MySharedPref.getToken()!;
    return await http.get(Uri.parse(url), headers: authHeaders(token: token));
  }

  static Future<http.Response> postWithAuth(String url, Map body) async {
    final ok = await _refreshTokenIfNeeded();
    if (!ok) throw Exception("Token expired - تسجيل دخول مطلوب");

    final token = MySharedPref.getToken()!;
    return await http.post(Uri.parse(url),
        headers: authHeaders(token: token), body: json.encode(body));
  }

  static Future<http.Response> putWithAuth(String url, Map body) async {
    final ok = await _refreshTokenIfNeeded();
    if (!ok) throw Exception("Token expired - تسجيل دخول مطلوب");

    final token = MySharedPref.getToken()!;
    return await http.put(Uri.parse(url),
        headers: authHeaders(token: token), body: json.encode(body));
  }

  static Future<http.Response> deleteWithAuth(String url) async {
    final ok = await _refreshTokenIfNeeded();
    if (!ok) throw Exception("Token expired - تسجيل دخول مطلوب");

    final token = MySharedPref.getToken()!;
    return await http.delete(Uri.parse(url),
        headers: authHeaders(token: token));
  }

  // ===================== المنتجات =====================
  static Future<List<ProductModel>> getHomePageProducts(
      {int pageSize = 10}) async {
    final url = Uri.parse("$productBaseUrl/data-home-page-product-cards");
    final response = await http.post(url,
        headers: headers, body: json.encode({"pageSize": pageSize}));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'] ?? [];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception(
          "فشل جلب المنتجات: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<ProductModel> getProductById(String productId) async {
    final url = Uri.parse(
        "$productBaseUrl/details-with-images-and-variants/$productId");
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(response.body);
      final data = jsonData['data']?['productDetails'] ?? jsonData['data'];
      return ProductModel.fromJson(data);
    } else {
      throw Exception(
          "فشل جلب تفاصيل المنتج: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<List<ProductSectionModel>> getProductSections() async {
    final url = Uri.parse("$productBaseUrl/category");
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'] ?? [];
      return data.map((e) => ProductSectionModel.fromJson(e)).toList();
    } else {
      throw Exception(
          "فشل جلب الأقسام: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<List<ProductSectionModel>> getBrands() async {
    final url = Uri.parse("$productBaseUrl/brand");
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'] ?? [];
      return data.map((e) => ProductSectionModel.fromJson(e)).toList();
    } else {
      throw Exception(
          "فشل جلب العلامات التجارية: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<List<ProductModel>> getProductsByCategory(
      String categoryId) async {
    final url = Uri.parse("$productBaseUrl/product-by-category");
    final response = await http.post(url,
        headers: headers, body: json.encode({"categoryId": categoryId}));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'] ?? [];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception(
          "فشل جلب منتجات القسم: ${response.statusCode} - ${response.body}");
    }
  }

  // ===================== باقي الدوال مثل التحقق بالبريد، البروفايل، السلة، العناوين =====================
  // استخدم postWithAuth/getWithAuth/putWithAuth/deleteWithAuth عند الحاجة لتوكن
  // لضمان التجديد التلقائي للتوكن دون كسر باقي الكود القديم
  // ===================== التحقق بالبريد =====================
  static Future<bool> sendVerificationCode(String email) async {
    final url = Uri.parse("$authBaseUrl/send-verification-code");
    final response = await http.post(url,
        headers: authHeaders(), body: json.encode({"email": email}));
    if (response.statusCode == 200) return true;
    throw Exception(
        "فشل إرسال كود التحقق: ${response.statusCode} - ${response.body}");
  }

  static Future<String> verifyCode(String email, String code) async {
    final url = Uri.parse("$authBaseUrl/verify-code");
    final response = await http.post(url,
        headers: authHeaders(),
        body: json.encode({
          "email": email,
          "code": code,
          "userAgent": "FlutterApp/1.0.0 (Android)"
        }));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body);
      if (data['isSuccess'] == true) return data['data']['token'];
      throw Exception(data['message'] ?? "فشل التحقق من الكود");
    } else {
      throw Exception(
          "فشل التحقق من الكود: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<String> completeRegistration({
    required String token,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    checkToken(token);
    final url = Uri.parse("$authBaseUrl/complete-registration");
    final response = await postWithAuth(url.toString(), {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone
    });

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body);
      if (data['isSuccess'] == true) return data['data']['token'];
      throw Exception(data['message'] ?? "فشل استكمال التسجيل");
    } else {
      throw Exception(
          "فشل استكمال التسجيل: ${response.statusCode} - ${response.body}");
    }
  }

// ===================== البروفايل =====================
  static Future<profileModel> getProfile(String token) async {
    checkToken(token);
    final url = "$customerBaseUrl/profile";
    final response = await getWithAuth(url);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(response.body);
      return profileModel.fromJson(jsonData['data']);
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: توكن غير صالح أو منتهي الصلاحية");
    } else {
      throw Exception(
          "فشل جلب البروفايل: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<bool> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    checkToken(token);
    final url = "$customerBaseUrl/profile";
    final response = await putWithAuth(url, {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone
    });

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body);
      return data['isSuccess'] ?? false;
    } else {
      print(
          "❌ فشل تحديث البروفايل: StatusCode=${response.statusCode}, Body='${response.body}'");
      return false;
    }
  }

  static Future<String> uploadProfileImage(String token, File imageFile) async {
    checkToken(token);
    final uri = Uri.parse("$customerBaseUrl/profile/upload-avatar");
    final request = http.MultipartRequest("POST", uri);
    request.headers
        .addAll({'Authorization': 'Bearer $token', 'Store-Domain': 'essam2'});
    request.files
        .add(await http.MultipartFile.fromPath("avatar", imageFile.path));
    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    final data = json.decode(resBody);
    if (response.statusCode == 200 && data['isSuccess'] == true) {
      return data['data']['avatarUrl'];
    } else {
      throw Exception(data['message'] ?? "فشل رفع الصورة");
    }
  }

// ===================== السلة =====================
  static Future<CartHeader> getCart({required String token}) async {
    checkToken(token);
    final url = "$cartBaseUrl/cart";
    final response = await getWithAuth(url);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body)['data'];
      return CartHeader.fromJson(data);
    } else {
      throw Exception(
          "فشل جلب السلة: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<CartDetail?> addCartItem({
    required String token,
    required int productId,
    required int productVariantId,
    required int quantity,
    required double unitPrice,
    String? note,
  }) async {
    final url = "$cartBaseUrl/cart/add";
    final body = {
      "productId": productId,
      "productVariantId": productVariantId,
      "quantity": quantity,
      "unitPrice": unitPrice,
      "note": note ?? '',
    };
    final response = await postWithAuth(url, body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return CartDetail.fromJson(data);
    } else {
      print("❌ Server error: ${response.body}");
      return null;
    }
  }

  static Future<bool> deleteCartItem({
    required String token,
    required int cartDetailId,
  }) async {
    checkToken(token);
    final url = "$cartBaseUrl/details/$cartDetailId";
    final response = await deleteWithAuth(url);

    return response.statusCode == 200;
  }

// ===================== العناوين =====================
  static Future<List<CustomerAddress>> getCustomerAddresses(
      {required String token}) async {
    checkToken(token);
    final url = addressBaseUrl;
    final response = await getWithAuth(url);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = json.decode(response.body);
      final data = body['data'] as List<dynamic>? ?? [];
      return data.map((e) => CustomerAddress.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<bool> addCustomerAddress(
      {required String token, required CustomerAddress address}) async {
    checkToken(token);
    final url = addressBaseUrl;
    final response = await postWithAuth(url, address.toJson());
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body);
      return data['isSuccess'] ?? false;
    } else {
      return false;
    }
  }

  static Future<bool> updateCustomerAddress(
      {required String token, required CustomerAddress address}) async {
    checkToken(token);
    final url = "$addressBaseUrl/${address.publicId}";
    final response = await putWithAuth(url, address.toJson());

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body);
      return data['isSuccess'] ?? false;
    } else {
      return false;
    }
  }

  static Future<bool> deleteCustomerAddress(
      {required String token, required String publicId}) async {
    checkToken(token);
    final url = "$addressBaseUrl/$publicId";
    final response = await deleteWithAuth(url);
    if (response.statusCode == 200 || response.statusCode == 204) return true;
    return false;
  }

  static Future<CustomerAddress?> getCustomerAddressById(
      {required String token, required String publicId}) async {
    checkToken(token);
    final url = "$addressBaseUrl/$publicId";
    final response = await getWithAuth(url);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body)['data'];
      if (data != null) return CustomerAddress.fromJson(data);
    }
    return null;
  }

// ===================== تحويل التوكن القصير إلى طويل =====================
  static Future<String> loginWithShortToken(String shortToken) async {
    checkToken(shortToken);
    final url = "$authBaseUrl/convert-token";
    final response = await postWithAuth(url, {});
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body);
      if (data['isSuccess'] == true && data['data']?['token'] != null) {
        return data['data']['token'];
      }
    }
    return '';
  }
}
