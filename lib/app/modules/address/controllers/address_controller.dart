import 'package:get/get.dart';
import '../../../data/api/api_service.dart';

class AddressController extends GetxController {
  var addresses = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  String? token; // توكن المستخدم
  final ApiService apiService = ApiService(); // ✅ هنا عملنا instance

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  // 🔹 جلب كل العناوين
  Future<void> fetchAddresses() async {
    if (token == null) return;
    try {
      isLoading.value = true;
      final data = await apiService.getCustomerAddresses(token: token); // 👈 استخدمنا instance
      addresses.assignAll(data.cast<Map<String, dynamic>>());
    } catch (e) {
      print("Error fetching addresses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 حذف عنوان
  Future<void> deleteAddress(String publicId) async {
    if (token == null) return;
    try {
      final success = await apiService.deleteCustomerAddress(publicId, token: token); // 👈 instance
      if (success) {
        addresses.removeWhere((a) => a['customerAddressPublicId'] == publicId);
      }
    } catch (e) {
      print("Error deleting address: $e");
    }
  }
}
