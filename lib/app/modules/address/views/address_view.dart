import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/no_data.dart';
import '../controllers/address_controller.dart';
import 'add_address_map_view.dart';

class AddressView extends StatelessWidget {
  final int customerId;
  final String token;

  AddressView({Key? key, required this.customerId, required this.token})
      : super(key: key) {
    if (!Get.isRegistered<AddressController>()) {
      Get.put(AddressController(token: token, customerId: customerId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'عناويني',
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchAddresses(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.addresses.isEmpty) {
          return const NoData(text: 'لا توجد عناوين بعد');
        }
        return ListView.separated(
          padding:
              const EdgeInsets.fromLTRB(16, 16, 16, 100), // padding سفلي فارغ
          itemCount: controller.addresses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final addr = controller.addresses[index];
            return ListTile(
              leading: const Icon(Icons.location_on, color: Colors.green),
              title: Text(addr.streetAddress1),
              subtitle:
                  Text('CityID: ${addr.cityId}, CountryID: ${addr.countryId}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () async {
                  if (addr.publicId.isEmpty) {
                    print("⚠️ لا يمكن حذف العنوان: publicId فارغ");
                    Get.snackbar("خطأ", "لا يمكن حذف العنوان: publicId فارغ");
                    return;
                  }
                  final result = await controller.deleteAddress(addr.publicId);
                  if (result) {
                    controller.fetchAddresses();
                  }
                },
              ),
            );
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 8),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Get.to(
                () => PickLocationPage(token: token, customerId: customerId));
            if (result == true) controller.fetchAddresses();
          },
          child: const Icon(Icons.add),
          backgroundColor: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
