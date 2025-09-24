import 'package:get/get.dart';
import '../../../data/models/CustomerAddress .dart';
import '../../../data/models/customer_address_ext.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/api/api_service.dart';

class AddressController extends GetxController {
  final int customerId;
  final String token;

  final RxList<CustomerAddress> addresses = <CustomerAddress>[].obs;
  final RxBool isLoading = false.obs;

  AddressController({
    required this.customerId,
    required this.token,
  }) {
    print("📌 AddressController initialized with customerId: $customerId");
    _loadLocalAddresses();
    if (customerId != 0 && token.isNotEmpty) {
      fetchAddresses();
    }
  }

  void _loadLocalAddresses() {
    print("🔹 Loading addresses from SharedPreferences...");
    final saved = MySharedPref.getAddresses();
    if (saved.isNotEmpty) {
      addresses.value = saved.map((e) => CustomerAddressJsonExt.fromJsonString(e as String)).toList();
      print("✅ Loaded ${addresses.length} addresses from local storage.");
    } else {
      print("⚠️ No addresses found in SharedPreferences.");
    }
  }

  void _saveLocalAddresses() {
    final list = addresses.map((e) => e.toJsonString()).toList();
    MySharedPref.setAddresses(list.cast<CustomerAddress>());
    print("💾 Saved ${list.length} addresses to SharedPreferences.");
  }

  Future<void> fetchAddresses() async {
    if (customerId == 0 || token.isEmpty) {
      print("⚠️ fetchAddresses skipped: invalid customerId or token.");
      return;
    }

    isLoading.value = true;
    print("🌐 Fetching addresses from server...");
    try {
      final result = await ApiService.getCustomerAddresses(token: token);

      List<CustomerAddress> list = [];
      for (var e in result) {
        if (e is CustomerAddress) list.add(e);
        else if (e is String) list.add(CustomerAddressJsonExt.fromJsonString(e as String));
      }

      addresses.value = list;
      print("✅ Fetched ${addresses.length} addresses from server.");
      _saveLocalAddresses();
    } catch (e) {
      print("🚨 Error fetching addresses: $e");
    } finally {
      isLoading.value = false;
      print("🔹 fetchAddresses finished. isLoading = ${isLoading.value}");
    }
  }

  Future<void> deleteAddress(String publicId) async {
    if (token.isEmpty) return;
    print("🗑️ Deleting address with publicId: $publicId");
    try {
      final success = await ApiService.deleteCustomerAddress(token: token, publicId: publicId);
      if (success) {
        addresses.removeWhere((a) => a.customerAddressPublicId == publicId);
        _saveLocalAddresses();
        print("✅ Address deleted successfully: $publicId");
      } else {
        print("❌ Failed to delete address: $publicId");
      }
    } catch (e) {
      print("🚨 Error deleting address: $e");
    }
  }

  Future<void> addAddress(CustomerAddress newAddress) async {
    addresses.add(newAddress);
    _saveLocalAddresses();
    print("➕ Added new address: ${newAddress.customerAddressPublicId}");
  }
}
