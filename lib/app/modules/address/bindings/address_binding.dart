import 'package:get/get.dart';
import '../controllers/address_controller.dart';

class AddressBinding extends Bindings {
  final int? customerId;
  final String? token;
  final String? userPhone;

  AddressBinding({this.customerId, this.token, this.userPhone});

  @override
  void dependencies() {
    // سجل Controller بطريقة آمنة
    Get.lazyPut<AddressController>(() => AddressController(
          customerId: customerId ?? 0, // 0 كقيمة افتراضية
          token: token ?? '',
          userPhone: userPhone,
        ));
  }
}
