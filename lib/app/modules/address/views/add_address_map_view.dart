import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import '../../../data/models/CustomerAddress .dart';
import '../../../data/api/api_service.dart';

class PickLocationPage extends StatelessWidget {
  final String token;
  final int customerId; // للـ API
  final String? userPhone;

  const PickLocationPage({
    Key? key,
    required this.token,
    required this.customerId,
    this.userPhone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController(text: userPhone ?? "");

    return Scaffold(
      appBar: AppBar(title: const Text("اختيار الموقع")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "رقم الهاتف",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FlutterLocationPicker(
              userAgent: "grocery_app/1.0 (essam-tech)",
              initPosition: LatLong(15.3694, 44.1910),
              initZoom: 12,
              minZoomLevel: 3,
              maxZoomLevel: 18,
              trackMyPosition: true,
              onPicked: (pickedData) async {
                final phone = phoneController.text.trim();
                if (phone.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("❌ الرجاء إدخال رقم الهاتف")),
                  );
                  return;
                }

                // ✅ إنشاء العنوان الجديد متوافق مع constructor الحالي
                final newAddress = CustomerAddress(
                  id: 0, // معرف جديد للعنوان
                  customerId: customerId,
                  streetAddress1: pickedData.address,
                  streetAddress2: pickedData.address.isNotEmpty == true
                      ? pickedData.address
                      : "",
                  cityId: 1,
                  regionId: 1,
                  countryId: 1,
                  postalCode: "",
                  phone: phone,
                  isDefault: false,
                  latitude: pickedData.latLong.latitude,
                  longitude: pickedData.latLong.longitude,
                );

                try {
                  final success = await ApiService.addCustomerAddress(
                    token: token,
                    address: newAddress,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("✅ تم حفظ العنوان بنجاح")),
                    );
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("⚠️ فشل حفظ العنوان")),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("❌ خطأ: $e")),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
