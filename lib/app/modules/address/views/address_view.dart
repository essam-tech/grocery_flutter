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
        title: Text('Addresses', style: theme.textTheme.titleLarge),
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
          return const NoData(text: 'No addresses found');
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.addresses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final CustomerAddress addr = controller.addresses[index];
            final titleText =
                addr.streetAddress1.isNotEmpty ? addr.streetAddress1 : '—';
            final subtitleText =
                'City ID: ${addr.cityId}, Country ID: ${addr.countryId}';

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: Colors.black26,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // يمكنك إضافة فتح الخريطة أو تعديل العنوان هنا
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titleText,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              subtitleText,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          controller.deleteAddress(addr.id);
                        },
                      ),
                    ],
                  ),
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
                  token: token,
                  customerId: customerId,
                ));
            if (result == true) controller.fetchAddresses();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
