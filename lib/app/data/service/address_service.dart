import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/CustomerAddress .dart';

class AddressService {
  // 🔗 رابط السيرفر الأساسي
  final String baseUrl = "https://maqadhi.com:56976/api";

  // ✅ جلب كل العناوين الخاصة بالعميل
  Future<List<CustomerAddress>> fetchAddresses(
      String token, int customerId) async {
    if (token.isEmpty || customerId == 0) {
      print("⚠️ fetchAddresses skipped: invalid customerId or token.");
      return [];
    }

    final url = Uri.parse("$baseUrl/v2/customer-address/customer/$customerId");
    print("📡 جلب العناوين من: $url");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("📥 كود الاستجابة: ${response.statusCode}");
    print("📦 محتوى الرد: ${response.body}");

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => CustomerAddress.fromJson(json)).toList();
        } else {
          print("⚠️ الرد ليس List، سيتم إرجاع قائمة فارغة");
          return [];
        }
      } catch (e) {
        print("🚨 خطأ في تحليل JSON: $e");
        return [];
      }
    } else {
      throw Exception("❌ فشل تحميل العناوين: ${response.body}");
    }
  }

  // ✅ إضافة عنوان جديد
  Future<CustomerAddress> addAddress(
      String token, int customerId, CustomerAddress address) async {
    final url = Uri.parse("$baseUrl/v2/customer-address");
    print("📤 إرسال عنوان جديد إلى: $url");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(address.toJson()),
    );

    print("📥 كود الاستجابة: ${response.statusCode}");
    print("📦 محتوى الرد: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CustomerAddress.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("❌ فشل إضافة العنوان: ${response.body}");
    }
  }

  // ✅ حذف عنوان باستخدام الـ publicId
  Future<bool> deleteAddress(String token, String publicId) async {
    if (token.isEmpty || publicId.isEmpty) {
      print("⚠️ deleteAddress skipped: invalid token or publicId");
      return false;
    }

    final url = Uri.parse("$baseUrl/v2/customer-address/$publicId");
    print("📤 إرسال طلب حذف إلى: $url");

    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("📥 كود الاستجابة: ${response.statusCode}");
    print("📦 محتوى الرد: '${response.body}'");

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("✅ تم حذف العنوان بنجاح: $publicId");
      return true;
    } else {
      print("❌ فشل حذف العنوان (${response.statusCode}): ${response.body}");
      return false;
    }
  }
}
