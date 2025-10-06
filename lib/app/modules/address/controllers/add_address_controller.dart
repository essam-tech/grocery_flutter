import 'package:get/get.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../data/models/CustomerAddress .dart';
import '../../../modules/address/controllers/address_controller.dart';

class AddAddressController extends GetxController {
  GeoPoint? selectedPoint;
  final int customerId;
  final String? userPhone;

  AddAddressController({
    required this.customerId,
    this.userPhone,
  }) {
    print("📌 AddAddressController initialized for customerId: $customerId");
  }

  void setSelectedPoint(GeoPoint point) {
    selectedPoint = point;
    print(
        "📍 تم اختيار الموقع: Latitude=${point.latitude}, Longitude=${point.longitude}");
    update();
  }

  Future<bool> saveAddress(String token) async {
    if (selectedPoint == null) {
      print("⚠️ لم يتم اختيار أي موقع بعد! لا يمكن الحفظ.");
      return false;
    }

    final newAddress = CustomerAddress(
      id: 0,
      publicId: "", // 🔹 سيتم توليده من السيرفر
      customerId: customerId,
      streetAddress1: "موقع من الخريطة",
      streetAddress2: "",
      cityId: 1,
      regionId: 1,
      countryId: 1,
      postalCode: "",
      phone: userPhone?.isNotEmpty == true ? userPhone! : "000000000",
      isDefault: false,
      latitude: selectedPoint!.latitude,
      longitude: selectedPoint!.longitude,
    );

    print("💾 جاري إرسال العنوان للسيرفر...");
    print("🔹 البيانات المرسلة:\n${newAddress.toJson()}");

    try {
      await Get.find<AddressController>().addAddress(newAddress);
      return true;
    } catch (e) {
      print("🚨 حدث خطأ أثناء حفظ العنوان: $e");
      return false;
    } finally {
      print("🔹 saveAddress انتهت العملية.");
    }
  }
}
