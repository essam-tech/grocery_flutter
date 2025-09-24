import 'package:get/get.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../data/models/CustomerAddress .dart';
import '../../../data/api/api_service.dart';

class AddAddressController extends GetxController {
  GeoPoint? selectedPoint; // الموقع المختار
  final int customerId; // رقم المستخدم الحالي
  final String? userPhone; // رقم الهاتف من المستخدم

  AddAddressController({
    required this.customerId,
    this.userPhone,
  }) {
    print("📌 AddAddressController initialized for customerId: $customerId");
  }

  /// لتحديث الموقع عند الضغط على الخريطة
  void setSelectedPoint(GeoPoint point) {
    selectedPoint = point;
    print(
        "📍 تم اختيار الموقع: Latitude=${point.latitude}, Longitude=${point.longitude}");
    update(); // لتحديث الواجهة لو استخدمنا GetBuilder
  }

  /// حفظ العنوان على السيرفر
  Future<bool> saveAddress(String token) async {
    if (selectedPoint == null) {
      print("⚠️ لم يتم اختيار أي موقع بعد! لا يمكن الحفظ.");
      return false;
    }

    final newAddress = CustomerAddress(
      customerAddressId: 0,
      customerAddressPublicId: "",
      customerId: customerId,
      streetAddress1: "موقع من الخريطة",
      streetAddress2: "",
      cityId: 1,
      cityName: "Sana'a",
      regionId: 1,
      regionName: "Amanat Al Asimah",
      countryId: 1,
      countryName: "Yemen",
      postalCode: "",
      phone: userPhone?.isNotEmpty == true ? userPhone! : "000000000",
      isDefault: false,
      latitude: selectedPoint!.latitude,
      longitude: selectedPoint!.longitude,
    );

    print("💾 جاري إرسال العنوان للسيرفر...");
    print("🔹 البيانات المرسلة:\n${newAddress.toJson()}");

    try {
      final success = await ApiService.addCustomerAddress(
        token: token,
        address: newAddress,
      );

      if (success) {
        print("✅ تم حفظ العنوان بنجاح!");
      } else {
        print("❌ فشل حفظ العنوان على السيرفر.");
      }

      return success;
    } catch (e, stackTrace) {
      print("🚨 حدث خطأ أثناء حفظ العنوان: $e");
      print("📜 تفاصيل الخطأ:\n$stackTrace");
      return false;
    } finally {
      print("🔹 saveAddress انتهت العملية.");
    }
  }
}
