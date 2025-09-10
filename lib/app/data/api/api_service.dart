import 'dart:convert';
import 'dart:io';
import 'package:grocery_app/app/data/models/cart_model.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/product_section_model.dart';
import '../models/ProfileModel.dart';

class ApiService {
  // 🔗 الرابط الأساسي للمنتجات
  static const String baseUrl = "https://maqadhi.com:56975/api/v2/product";

  // 🔗 الرابط الأساسي للتحقق والتسجيل والبروفايل
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
    try {
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
    } catch (e) {
      throw Exception("خطأ أثناء جلب المنتجات: $e");
    }
  }

  // ------------------ تفاصيل المنتج ------------------
  static Future<ProductModel> getProductById(String productId) async {
    final url =
        Uri.parse("$baseUrl/details-with-images-and-variants/$productId");
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data']?['productDetails'] ?? jsonData['data'];
        return ProductModel.fromJson(data);
      } else {
        throw Exception(
            "فشل جلب تفاصيل المنتج: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("خطأ أثناء جلب تفاصيل المنتج: $e");
    }
  }

  // ------------------ أقسام المنتج ------------------
  static Future<List<ProductSectionModel>> getProductSections(
      String productId) async {
    final url = Uri.parse("$baseUrl/sections/$productId");
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        return data.map((e) => ProductSectionModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("خطأ أثناء جلب أقسام المنتج: $e");
      return [];
    }
  }

  // ------------------ إرسال كود التحقق ------------------
  static Future<bool> sendVerificationCode(String email) async {
    final url =
        Uri.parse("$authBaseUrl/email-verification/send-verification-code");
    try {
      final response = await http.post(
        url,
        headers: authHeaders(),
        body: json.encode({"email": email}),
      );
      if (response.statusCode == 200) return true;
      throw Exception("فشل إرسال كود التحقق: ${response.body}");
    } catch (e) {
      throw Exception("خطأ أثناء إرسال كود التحقق: $e");
    }
  }

  // ------------------ التحقق من الكود ------------------
  static Future<String> verifyCode(String email, String code) async {
    final url = Uri.parse("$authBaseUrl/email-verification/verify-code");
    try {
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
    } catch (e) {
      throw Exception("خطأ أثناء التحقق من الكود: $e");
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
    try {
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
    } catch (e) {
      throw Exception("خطأ أثناء استكمال التسجيل: $e");
    }
  }

  // ------------------ جلب بيانات البروفايل ------------------
  static Future<profileModel> getProfile(String token) async {
    final url = Uri.parse("$authBaseUrl/customer/profile");
    try {
      final response = await http.get(url, headers: authHeaders(token: token));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];
        return profileModel.fromJson(data);
      } else {
        throw Exception(
            "فشل جلب البروفايل: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("خطأ أثناء جلب البروفايل: $e");
    }
  }

  // ------------------ تعديل بيانات البروفايل ------------------
  static Future<bool> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    final url = Uri.parse("$authBaseUrl/customer/profile");
    try {
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
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess'] == true) return true;
        throw Exception(data['message'] ?? "فشل تعديل البيانات");
      } else {
        throw Exception(
            "فشل تعديل البروفايل: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("خطأ أثناء تعديل البروفايل: $e");
    }
  }

  // ------------------ رفع صورة البروفايل ------------------
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
      return data['data']['avatarUrl']; // رابط الصورة بعد رفعها
    } else {
      throw Exception(data['message'] ?? "فشل رفع الصورة");
    }
  }

  // ------------------ جلب السلة ------------------
  static Future<CartHeader> getCart() async {
    final url = Uri.parse("$authBaseUrl/cart/cart");
    try {
      final response = await http.get(url, headers: authHeaders());
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return CartHeader.fromJson(data);
      } else {
        throw Exception(
            "فشل جلب السلة: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("خطأ أثناء جلب السلة: $e");
    }
  }

// ------------------ إضافة عنصر للسلة ------------------
  static Future<CartDetail> addCartItem({
    required int productId,
    required int productVariantId,
    required int quantity,
    required double unitPrice,
    String note = '',
  }) async {
    final url = Uri.parse("$authBaseUrl/cart/cart-details");
    try {
      final response = await http.post(
        url,
        headers: authHeaders(),
        body: json.encode({
          "productId": productId,
          "productVariantId": productVariantId,
          "quantity": quantity,
          "unitPrice": unitPrice,
          "note": note,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return CartDetail.fromJson(data);
      } else {
        throw Exception(
            "فشل إضافة عنصر للسلة: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("خطأ أثناء إضافة عنصر للسلة: $e");
    }
  }

// ------------------ تحديث عنصر في السلة ------------------
  static Future<CartDetail> updateCartItem({
    required int cartDetailId,
    required int quantity,
  }) async {
    final url = Uri.parse("$authBaseUrl/cart/details/$cartDetailId");
    try {
      final response = await http.put(
        url,
        headers: authHeaders(),
        body: json.encode({"quantity": quantity}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'][0];
        return CartDetail.fromJson(data);
      } else {
        throw Exception(
            "فشل تحديث العنصر: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("خطأ أثناء تحديث العنصر: $e");
    }
  }

// ------------------ حذف عنصر من السلة ------------------
  static Future<bool> deleteCartItem(int cartDetailId) async {
    final url = Uri.parse("$authBaseUrl/cart/details/$cartDetailId");
    try {
      final response = await http.delete(url, headers: authHeaders());
      return response.statusCode == 200;
    } catch (e) {
      throw Exception("خطأ أثناء حذف العنصر: $e");
    }
  }

// ------------------ تفريغ السلة بالكامل ------------------
  static Future<bool> clearCart(int cartHeaderId) async {
    final url = Uri.parse("$authBaseUrl/cart/$cartHeaderId/clear");
    try {
      final response = await http.delete(url, headers: authHeaders());
      return response.statusCode == 200;
    } catch (e) {
      throw Exception("خطأ أثناء تفريغ السلة: $e");
    }
  }
}
