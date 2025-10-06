import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import '../../../data/models/CustomerAddress .dart';
import '../../../modules/address/controllers/address_controller.dart';
import 'package:get/get.dart';

class PickLocationPage extends StatelessWidget {
  final int customerId;
  final String token;
  final String? userPhone;

  const PickLocationPage({
    Key? key,
    required this.customerId,
    required this.token,
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

                final newAddress = CustomerAddress(
                  id: 0,
                  publicId: "",
                  customerId: customerId,
                  streetAddress1: pickedData.address,
                  streetAddress2: pickedData.address.isNotEmpty ? pickedData.address : "",
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
                  final controller = Get.find<AddressController>();
                  await controller.addAddress(newAddress);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("✅ تم إضافة العنوان بنجاح")),
                  );
                  Navigator.pop(context, true);
                } catch (e) {
                  print("🚨 خطأ أثناء إضافة العنوان: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("❌ خطأ أثناء إضافة العنوان: $e")),
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
