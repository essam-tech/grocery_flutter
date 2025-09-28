import 'package:get/get.dart';
import '../../../data/models/CustomerAddress .dart';
import '../../../data/api/api_service.dart';

class AddressController extends GetxController {
  final int customerId;
  final String token;

  AddressController({
    required this.customerId,
    required this.token,
  });

  var isLoading = false.obs;
  var addresses = <CustomerAddress>[].obs;

  /// جلب العناوين من السيرفر
  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      final data = await ApiService.getCustomerAddresses(token: token);
      addresses.assignAll(data);
    } catch (e) {
      print("❌ فشل جلب العناوين: $e");
      addresses.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// حذف عنوان باستخدام الـ id من المودل الجديد
  Future<void> deleteAddress(int id) async {
    try {
      isLoading.value = true;
      final success = await ApiService.deleteCustomerAddress(token: token, id: id);
      if (success) {
        // إزالة العنوان من القائمة مباشرة بعد الحذف الناجح
        addresses.removeWhere((addr) => addr.id == id);
        Get.snackbar("نجاح", "تم حذف العنوان بنجاح");
      } else {
        Get.snackbar("خطأ", "فشل حذف العنوان");
      }
    } catch (e) {
      print("❌ خطأ أثناء الحذف: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء حذف العنوان");
    } finally {
      isLoading.value = false;
    }
  }
}
