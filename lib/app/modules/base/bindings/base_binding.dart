import 'package:get/get.dart';
import '../../category/controllers/category_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/ProfileController.dart';
import '../controllers/base_controller.dart';


class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseController>(() => BaseController());

    Get.lazyPut<HomeController>(() => HomeController());

    Get.lazyPut<CategoryController>(() => CategoryController());

    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
