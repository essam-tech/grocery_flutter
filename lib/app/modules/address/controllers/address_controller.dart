import 'package:get/get.dart';
import '../../../data/models/CustomerAddress .dart';
import '../../../data/api/api_service.dart';

class AddressController extends GetxController {
  final String token;
  final int customerId;

  AddressController({
    required this.token,
    required this.customerId,
  });

  var isLoading = false.obs;
  var addresses = <CustomerAddress>[].obs;

  // ------------------ 🔹 جلب العناوين ------------------
  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      final data = await ApiService.getCustomerAddresses(token: token);
      addresses.assignAll(data);
      data.forEach((a) {
        print("🧭 عنوان موجود: id=${a.id}, publicId=${a.publicId}");
      });
      print("📌 تم جلب ${data.length} عنوان من السيرفر");
    } catch (e) {
      print("❌ فشل جلب العناوين: $e");
      addresses.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ 🔹 حذف عنوان ------------------
  Future<bool> deleteAddress(String publicId) async {
    if (publicId.isEmpty) {
      print("⚠️ لا يمكن حذف العنوان: publicId فارغ");
      return false;
    }

    try {
      isLoading.value = true;
      final success = await ApiService.deleteCustomerAddress(
        token: token,
        publicId: publicId,
      );
      if (success) {
        addresses.removeWhere((addr) => addr.publicId == publicId);
        print("🗑️ تم حذف العنوان publicId=$publicId");
      } else {
        print("⚠️ فشل حذف العنوان publicId=$publicId");
      }
      return success;
    } catch (e) {
      print("🚨 خطأ أثناء الحذف: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ 🔹 إضافة عنوان ------------------
  Future<void> addAddress(CustomerAddress address) async {
    try {
      isLoading.value = true;
      final success = await ApiService.addCustomerAddress(
        token: token,
        address: address,
      );
      if (success) {
        print("✅ تم إرسال العنوان للسيرفر بنجاح");
        await fetchAddresses(); // تحديث القائمة بعد الإضافة
      } else {
        print("❌ فشل إرسال العنوان للسيرفر");
      }
    } catch (e) {
      print("🚨 خطأ أثناء إضافة العنوان: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
