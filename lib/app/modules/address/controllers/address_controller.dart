import 'package:get/get.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/CustomerAddress .dart';

class AddressController extends GetxController {
  var addresses = <CustomerAddress>[].obs;
  var isLoading = false.obs;

  String? token; // توكن المستخدم
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    if (token == null) return;
    try {
      isLoading.value = true;
      final data = await apiService.getCustomerAddresses(token: token);
      addresses.assignAll(data);
    } catch (e) {
      print("Error fetching addresses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(String publicId) async {
    if (token == null) return;
    try {
      final success = await apiService.deleteCustomerAddress(publicId, token: token);
      if (success) {
        addresses.removeWhere((a) => a.customerAddressPublicId == publicId);
      }
    } catch (e) {
      print("Error deleting address: $e");
    }
  }

  Future<void> addAddress(CustomerAddress newAddress) async {
    if (token == null) return;
    try {
      final success = await apiService.addCustomerAddress(newAddress, token: token);
      if (success) await fetchAddresses();
    } catch (e) {
      print("Error adding address: $e");
    }
  }

  Future<void> updateAddress(CustomerAddress updatedAddress) async {
    if (token == null) return;
    try {
      final success = await apiService.updateCustomerAddress(
        updatedAddress.customerAddressPublicId, 
        updatedAddress,
        token: token
      );
      if (success) {
        final index = addresses.indexWhere(
          (a) => a.customerAddressPublicId == updatedAddress.customerAddressPublicId
        );
        if (index != -1) addresses[index] = updatedAddress;
      }
    } catch (e) {
      print("Error updating address: $e");
    }
  }
}
