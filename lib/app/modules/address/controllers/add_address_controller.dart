import 'package:get/get.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../data/models/CustomerAddress .dart';
import '../../../data/api/api_service.dart';

class AddAddressController extends GetxController {
  GeoPoint? selectedPoint; // الموقع المختار
  final ApiService api = ApiService();

  // لتحديث الموقع عند الضغط على الخريطة
  void setSelectedPoint(GeoPoint point) {
    selectedPoint = point;
    update(); // لتحديث الواجهة لو استخدمنا GetBuilder
  }

  // حفظ العنوان على السيرفر
  Future<bool> saveAddress(String token) async {
    if (selectedPoint == null) return false;

    final newAddress = CustomerAddress(
      customerAddressId: 0,
      customerAddressPublicId: "",
      streetAddress1: "موقع من الخريطة",
      streetAddress2: "",
      cityId: 0,
      cityName: "",
      regionId: 0,
      regionName: "",
      countryId: 0,
      countryName: "",
      postalCode: "",
      phone: "",
      isDefault: false,
      latitude: selectedPoint!.latitude,
      longitude: selectedPoint!.longitude,
    );

    return await api.addCustomerAddress(newAddress, token: token);
  }
}
