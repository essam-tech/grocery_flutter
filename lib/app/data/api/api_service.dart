import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/product_section_model.dart';
import '../models/cart_model.dart';
import '../models/ProfileModel.dart';
import '../models/CustomerAddress .dart';

class ApiService {
  // ===================== روابط API الأساسية =====================
  static const String productBaseUrl = "https://maqadhi.com:56976/api/v2/store/product";
  static const String authBaseUrl = "https://maqadhi.com:56976/api/v2/store/email-verification";
  static const String customerBaseUrl = "https://maqadhi.com:56976/api/v2/store/customer";
  static const String cartBaseUrl = "https://maqadhi.com:56976/api/v2/store/cart";
  static const String addressBaseUrl = "https://maqadhi.com:56976/api/v2/store/customer-address";

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

  // ===================== التحقق من صلاحية التوكن =====================
  static void checkToken(String? token) {
    if (token == null || token.isEmpty) {
      throw Exception("⚠️ توكن غير صالح أو فارغ");
    }
  }

  // ===================== المنتجات =====================
  static Future<List<ProductModel>> getHomePageProducts({int pageSize = 10}) async {
    final url = Uri.parse("$productBaseUrl/data-home-page-product-cards");
    final response = await http.post(url, headers: headers, body: json.encode({"pageSize": pageSize}));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'] ?? [];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("فشل جلب المنتجات: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<ProductModel> getProductById(String productId) async {
    final url = Uri.parse("$productBaseUrl/details-with-images-and-variants/$productId");
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(response.body);
      final data = jsonData['data']?['productDetails'] ?? jsonData['data'];
      return ProductModel.fromJson(data);
    } else {
      throw Exception("فشل جلب تفاصيل المنتج: ${response.statusCode} - ${response.body}");
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
      throw Exception("فشل جلب الأقسام: ${response.statusCode} - ${response.body}");
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
      throw Exception("فشل جلب العلامات التجارية: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final url = Uri.parse("$productBaseUrl/product-by-category");
    final response = await http.post(url, headers: headers, body: json.encode({"categoryId": categoryId}));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'] ?? [];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("فشل جلب منتجات القسم: ${response.statusCode} - ${response.body}");
    }
  }

  // ===================== التحقق بالبريد =====================
  static Future<bool> sendVerificationCode(String email) async {
    final url = Uri.parse("$authBaseUrl/send-verification-code");
    final response = await http.post(url, headers: authHeaders(), body: json.encode({"email": email}));
    if (response.statusCode == 200) return true;
    throw Exception("فشل إرسال كود التحقق: ${response.statusCode} - ${response.body}");
  }

  static Future<String> verifyCode(String email, String code) async {
    final url = Uri.parse("$authBaseUrl/verify-code");
    final response = await http.post(url,
        headers: authHeaders(),
        body: json.encode({"email": email, "code": code, "userAgent": "FlutterApp/1.0.0 (Android)"}));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body);
      if (data['isSuccess'] == true) return data['data']['token'];
      throw Exception(data['message'] ?? "فشل التحقق من الكود");
    } else {
      throw Exception("فشل التحقق من الكود: ${response.statusCode} - ${response.body}");
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
    final response = await http.post(url,
        headers: authHeaders(token: token),
        body: json.encode({"firstName": firstName, "lastName": lastName, "email": email, "phone": phone}));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body);
      if (data['isSuccess'] == true) return data['data']['token'];
      throw Exception(data['message'] ?? "فشل استكمال التسجيل");
    } else {
      throw Exception("فشل استكمال التسجيل: ${response.statusCode} - ${response.body}");
    }
  }

  // ===================== البروفايل =====================
  static Future<profileModel> getProfile(String token) async {
    checkToken(token);
    final url = Uri.parse("$customerBaseUrl/profile");
    final response = await http.get(url, headers: authHeaders(token: token));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final jsonData = json.decode(response.body);
      return profileModel.fromJson(jsonData['data']);
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: توكن غير صالح أو منتهي الصلاحية");
    } else {
      throw Exception("فشل جلب البروفايل: ${response.statusCode} - ${response.body}");
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
    final url = Uri.parse("$customerBaseUrl/profile");
    final response = await http.put(url,
        headers: authHeaders(token: token), body: json.encode({"firstName": firstName, "lastName": lastName, "email": email, "phone": phone}));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body);
      return data['isSuccess'] ?? false;
    } else {
      print("❌ فشل تحديث البروفايل: StatusCode=${response.statusCode}, Body='${response.body}'");
      return false;
    }
  }

  static Future<String> uploadProfileImage(String token, File imageFile) async {
    checkToken(token);
    final uri = Uri.parse("$customerBaseUrl/profile/upload-avatar");
    final request = http.MultipartRequest("POST", uri);
    request.headers.addAll({'Authorization': 'Bearer $token', 'Store-Domain': 'essam2'});
    request.files.add(await http.MultipartFile.fromPath("avatar", imageFile.path));
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
    final url = Uri.parse("$cartBaseUrl/cart");
    final response = await http.get(url, headers: authHeaders(token: token));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body)['data'];
      return CartHeader.fromJson(data);
    } else {
      throw Exception("فشل جلب السلة: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<CartDetail?> addCartItem({
    required String token,
    required int productId,
    required int productVariantId,
    required int quantity,
    required double unitPrice,
    String note = '',
  }) async {
    checkToken(token);
    final url = Uri.parse("$cartBaseUrl/cart-details");
    final response = await http.post(url,
        headers: authHeaders(token: token),
        body: json.encode({
          "productId": productId,
          "productVariantId": productVariantId,
          "quantity": quantity,
          "unitPrice": unitPrice,
          "note": note,
        }));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = json.decode(response.body)['data'];
      if (data != null) return CartDetail.fromJson(data);
    }
    print("⚠️ فشل إضافة العنصر للسلة أو body فارغ: ${response.body}");
    return null;
  }

  static Future<bool> deleteCartItem({required String token, required int cartDetailId}) async {
    checkToken(token);
    final url = Uri.parse("$cartBaseUrl/details/$cartDetailId");
    final response = await http.delete(url, headers: authHeaders(token: token));
    return response.statusCode == 200;
  }

  // ===================== العناوين =====================
  static Future<List<CustomerAddress>> getCustomerAddresses({required String token}) async {
    checkToken(token);
    final url = Uri.parse(addressBaseUrl);
    try {
      final response = await http.get(url, headers: authHeaders(token: token));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final body = json.decode(response.body);
        final data = body['data'] as List<dynamic>? ?? [];
        return data.map((e) => CustomerAddress.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: توكن غير صالح أو منتهي الصلاحية");
      } else {
        print("❌ فشل جلب العناوين: StatusCode=${response.statusCode}, Body='${response.body}'");
        return [];
      }
    } catch (e) {
      print("🚨 خطأ أثناء جلب العناوين: $e");
      return [];
    }
  }

  static Future<bool> addCustomerAddress({required String token, required CustomerAddress address}) async {
    checkToken(token);
    final url = Uri.parse(addressBaseUrl);
    try {
      final response = await http.post(url, headers: authHeaders(token: token), body: json.encode(address.toJson()));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = json.decode(response.body);
        return data['isSuccess'] ?? false;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: توكن غير صالح أو منتهي الصلاحية");
      } else {
        print("❌ فشل إضافة العنوان: StatusCode=${response.statusCode}, Body='${response.body}'");
        return false;
      }
    } catch (e) {
      print("🚨 خطأ أثناء إضافة العنوان: $e");
      return false;
    }
  }

  static Future<bool> updateCustomerAddress({required String token, required CustomerAddress address}) async {
    checkToken(token);
    if (address.publicId.isEmpty) {
      print("⚠️ updateCustomerAddress skipped: invalid publicId");
      return false;
    }
    final url = Uri.parse("$addressBaseUrl/${address.publicId}");
    try {
      final response = await http.put(url, headers: authHeaders(token: token), body: json.encode(address.toJson()));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = json.decode(response.body);
        return data['isSuccess'] ?? false;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: توكن غير صالح أو منتهي الصلاحية");
      } else {
        print("❌ فشل تحديث العنوان: StatusCode=${response.statusCode}, Body='${response.body}'");
        return false;
      }
    } catch (e) {
      print("🚨 خطأ أثناء تحديث العنوان: $e");
      return false;
    }
  }

  static Future<CustomerAddress?> getCustomerAddressById({required String token, required String publicId}) async {
    checkToken(token);
    final url = Uri.parse("$addressBaseUrl/$publicId");
    try {
      final response = await http.get(url, headers: authHeaders(token: token));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = json.decode(response.body)['data'];
        if (data != null) return CustomerAddress.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: توكن غير صالح أو منتهي الصلاحية");
      }
      print("⚠️ لم يتم العثور على العنوان أو body فارغ");
      return null;
    } catch (e) {
      print("🚨 خطأ أثناء جلب العنوان بالمعرف: $e");
      return null;
    }
  }

  static Future<bool> deleteCustomerAddress({required String token, required String publicId}) async {
    checkToken(token);
    if (publicId.isEmpty) {
      print("⚠️ deleteCustomerAddress skipped: invalid publicId");
      return false;
    }
    final url = Uri.parse("$addressBaseUrl/$publicId");
    try {
      final response = await http.delete(url, headers: authHeaders(token: token));
      if (response.statusCode == 200 || response.statusCode == 204) {
        print("✅ تم حذف العنوان بنجاح: $publicId");
        return true;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: توكن غير صالح أو منتهي الصلاحية");
      } else {
        print("❌ فشل حذف العنوان من السيرفر: ${response.statusCode}, Body='${response.body}'");
        return false;
      }
    } catch (e) {
      print("🚨 خطأ أثناء الحذف: $e");
      return false;
    }
  }
}
