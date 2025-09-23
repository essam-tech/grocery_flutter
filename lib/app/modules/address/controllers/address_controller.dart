import 'package:get/get.dart';
import '../../../data/models/CustomerAddress .dart';
import '../../../data/api/api_service.dart';

class AddressController extends GetxController {
  final int customerId;
  final String token;
  final String? userPhone;

  // Observables
  final addresses = <CustomerAddress>[].obs;
  final isLoading = false.obs;

  AddressController({
    required this.customerId,
    required this.token,
    this.userPhone,
  }) {
    if (customerId != 0 && token.isNotEmpty) {
      fetchAddresses();
    }
  }

  Future<void> fetchAddresses() async {
    if (customerId == 0 || token.isEmpty) return;
    isLoading.value = true;
    try {
      final result = await ApiService.getCustomerAddresses(token: token);
      addresses.value = result;
    } catch (e) {
      print("🚨 خطأ أثناء جلب العناوين: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(String publicId) async {
    if (token.isEmpty) return;
    try {
      final success =
          await ApiService.deleteCustomerAddress(token: token, publicId: publicId);
      if (success) fetchAddresses();
    } catch (e) {
      print("🚨 خطأ أثناء حذف العنوان: $e");
    }
  }
}
