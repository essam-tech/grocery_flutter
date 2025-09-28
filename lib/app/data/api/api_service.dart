import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/product_section_model.dart';
import '../models/cart_model.dart';
import '../models/ProfileModel.dart';
import '../models/CustomerAddress .dart';

class ApiService {
  // 🔗 الرابط الأساسي للمنتجات
  static const String baseUrl = "https://maqadhi.com:56975/api/v2/product";

  // 🔗 الرابط الأساسي للتحقق والتسجيل والبروفايل والسلة
  static const String authBaseUrl = "https://maqadhi.com:56976/api/v2";

  // 📝 Headers الثابتة للمنتجات
  static const Map<String, String> headers = {
    'Store-Domain': 'essam',
    'Content-Type': 'application/json',
  };

  // ------------------ Helper للهيدرز الخاصة بالـ Auth ------------------
  static Map<String, String> authHeaders({String? token}) {
    final map = {
      'Content-Type': 'application/json',
      'Store-Domain': 'essam',
    };
    if (token != null) {
      map['Authorization'] = 'Bearer $token';
    }
    return map;
  }

  // ------------------ منتجات الصفحة الرئيسية ------------------
  static Future<List<ProductModel>> getHomePageProducts(
      {int pageSize = 10}) async {
    final url = Uri.parse("$baseUrl/data-home-page-product-cards");
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({"pageSize": pageSize}),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'] ?? [];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception(
          "فشل جلب المنتجات: ${response.statusCode} - ${response.body}");
    }
  }

  // ------------------ تفاصيل المنتج ------------------
  static Future<ProductModel> getProductById(String productId) async {
    final url =
        Uri.parse("$baseUrl/details-with-images-and-variants/$productId");
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final data = jsonData['data']?['productDetails'] ?? jsonData['data'];
      return ProductModel.fromJson(data);
    } else {
      throw Exception(
          "فشل جلب تفاصيل المنتج: ${response.statusCode} - ${response.body}");
    }
  }

  // ------------------ أقسام المنتج ------------------
  static Future<List<ProductSectionModel>> getProductSections(
      String productId) async {
    final url = Uri.parse("$baseUrl/sections/$productId");
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'] ?? [];
      return data.map((e) => ProductSectionModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  // ------------------ إرسال كود التحقق ------------------
  static Future<bool> sendVerificationCode(String email) async {
    final url =
        Uri.parse("$authBaseUrl/email-verification/send-verification-code");
    final response = await http.post(
      url,
      headers: authHeaders(),
      body: json.encode({"email": email}),
    );
    if (response.statusCode == 200) return true;
    throw Exception("فشل إرسال كود التحقق: ${response.body}");
  }

  // ------------------ التحقق من الكود ------------------
  static Future<String> verifyCode(String email, String code) async {
    final url = Uri.parse("$authBaseUrl/email-verification/verify-code");
    final response = await http.post(
      url,
      headers: authHeaders(),
      body: json.encode({"email": email, "code": code}),
    );
    final data = json.decode(response.body);
    if (response.statusCode == 200 && data['isSuccess'] == true) {
      return data['data']['token'];
    } else {
      throw Exception(data['message'] ?? "فشل التحقق من الكود");
    }
  }

  // ------------------ استكمال التسجيل ------------------
  static Future<String> completeRegistration({
    required String token,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    final url =
        Uri.parse("$authBaseUrl/email-verification/complete-registration");
    final response = await http.post(
      url,
      headers: authHeaders(token: token),
      body: json.encode({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
      }),
    );
    final data = json.decode(response.body);
    if (response.statusCode == 200 && data['isSuccess'] == true) {
      return data['data']['token'];
    } else {
      throw Exception(data['message'] ?? "فشل استكمال التسجيل");
    }
  }

  // ------------------ البروفايل ------------------
  static Future<profileModel> getProfile(String token) async {
    final url = Uri.parse("$authBaseUrl/customer/profile");
    final response = await http.get(url, headers: authHeaders(token: token));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return profileModel.fromJson(jsonData['data']);
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
    final url = Uri.parse("$authBaseUrl/customer/profile");
    final response = await http.put(
      url,
      headers: authHeaders(token: token),
      body: json.encode({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
      }),
    );
    final data = json.decode(response.body);
    return (response.statusCode == 200 && data['isSuccess'] == true);
  }

  static Future<String> uploadProfileImage(String token, File imageFile) async {
    final uri = Uri.parse("$authBaseUrl/customer/profile/upload-avatar");
    final request = http.MultipartRequest("POST", uri);
    request.headers
        .addAll({'Authorization': 'Bearer $token', 'Store-Domain': 'essam'});
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

  // ------------------ السلة ------------------
  static Future<CartHeader> getCart({required String token}) async {
    final url = Uri.parse("$authBaseUrl/cart/cart");
    final response = await http.get(url, headers: authHeaders(token: token));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return CartHeader.fromJson(data);
    } else {
      throw Exception(
          "فشل جلب السلة: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<CartDetail> addCartItem({
    required String token,
    required int productId,
    required int productVariantId,
    required int quantity,
    required double unitPrice,
    String note = '',
  }) async {
    final url = Uri.parse("$authBaseUrl/cart/cart-details");
    final response = await http.post(
      url,
      headers: authHeaders(token: token),
      body: json.encode({
        "productId": productId,
        "productVariantId": productVariantId,
        "quantity": quantity,
        "unitPrice": unitPrice,
        "note": note,
      }),
    );
    final data = json.decode(response.body)['data'];
    return CartDetail.fromJson(data);
  }

  static Future<bool> deleteCartItem(
      {required String token, required int cartDetailId}) async {
    final url = Uri.parse("$authBaseUrl/cart/details/$cartDetailId");
    final response = await http.delete(url, headers: authHeaders(token: token));
    return response.statusCode == 200;
  }

  // ------------------ Customer Address ------------------
  static Future<bool> addCustomerAddress({
    required String token,
    required CustomerAddress address,
  }) async {
    final url = Uri.parse("$authBaseUrl/customer-address");
    final response = await http.post(
      url,
      headers: authHeaders(token: token),
      body: json.encode(address.toJson()),
    );
    final data = json.decode(response.body);
    return data['isSuccess'] ?? false;
  }

  static Future<List<CustomerAddress>> getCustomerAddresses(
      {required String token}) async {
    final url = Uri.parse("$authBaseUrl/customer-address");
    final response = await http.get(url, headers: authHeaders(token: token));
    final data = json.decode(response.body)['data'] as List<dynamic>;
    return data.map((e) => CustomerAddress.fromJson(e)).toList();
  }

  static Future<bool> deleteCustomerAddress({
    required String token,
    required int id, // بدل publicId
  }) async {
    final url =
        Uri.parse("$authBaseUrl/customer-address/$id"); // نرسل id في الرابط
    final response = await http.delete(url, headers: authHeaders(token: token));
    final data = json.decode(response.body);
    return data['isSuccess'] ?? false;
  }
}
