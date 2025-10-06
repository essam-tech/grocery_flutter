import 'package:get/get.dart';
import '../controllers/address_controller.dart';

class AddressBinding extends Bindings {
  final String? token;
  final int? customerId; // أضف هذا

  AddressBinding({this.token, this.customerId});

  @override
  void dependencies() {
    if (token != null && token!.isNotEmpty && customerId != null) {
      // سجل Controller بطريقة آمنة باستخدام token و customerId
      Get.lazyPut<AddressController>(
        () => AddressController(
          token: token!,
          customerId: customerId!,
        ),
      );
    }
  }
}
