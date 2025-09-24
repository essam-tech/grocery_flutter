import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/no_data.dart';
import '../controllers/address_controller.dart';
import 'add_address_map_view.dart';
import '../../../data/models/CustomerAddress .dart';

class AddressView extends StatelessWidget {
  final int customerId;
  final String token;

  AddressView({
    Key? key,
    required this.customerId,
    required this.token,
  }) : super(key: key) {
    // تسجيل الـController إذا لم يكن موجود
    if (!Get.isRegistered<AddressController>()) {
      Get.put(AddressController(
        customerId: customerId,
        token: token,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressController>();
    final theme = context.theme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Addresses', style: theme.textTheme.displaySmall),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchAddresses,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.addresses.isEmpty) {
          return const NoData(text: 'No addresses found');
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.addresses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final CustomerAddress addr = controller.addresses[index];
            final titleText = addr.streetAddress1?.isNotEmpty == true
                ? addr.streetAddress1!
                : '—';
            final subtitleText = [
              if ((addr.cityName?.isNotEmpty ?? false)) addr.cityName,
              if ((addr.countryName?.isNotEmpty ?? false)) addr.countryName,
            ].where((e) => e != null && e.isNotEmpty).join(', ');

            return Card(
              elevation: 2,
              child: ListTile(
                title: Text(titleText),
                subtitle: Text(subtitleText.isNotEmpty
                    ? subtitleText
                    : 'City ID: ${addr.cityId}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.deleteAddress(addr.customerAddressPublicId);
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          heroTag: 'add_address',
          child: const Icon(Icons.add),
          onPressed: () async {
            final result = await Get.to(() => PickLocationPage(
                  token: controller.token,
                  customerId: controller.customerId,
                ));
            if (result == true) controller.fetchAddresses();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
