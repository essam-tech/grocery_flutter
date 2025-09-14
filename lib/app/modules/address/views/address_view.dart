import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/no_data.dart';
import '../controllers/address_controller.dart';

class AdressView extends GetView<AddressController> {
  const AdressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Addresses', style: theme.textTheme.displaySmall),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
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
            final addr = controller.addresses[index];
            return Card(
              elevation: 2,
              child: ListTile(
                title: Text(addr['streetAddress1'] ?? ''),
                subtitle: Text('${addr['cityName'] ?? ''}, ${addr['countryName'] ?? ''}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.deleteAddress(addr['customerAddressPublicId']);
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // هنا تقدر تفتح شاشة إضافة عنوان جديد
        },
      ),
    );
  }
}
