import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  // فتح صفحة تفاصيل البروفايل (Login)
  void openProfileDetails() {
    Get.toNamed(Routes.LOGIN);
  }

  // فتح صفحة الإعدادات
  void openSettings() {
    Get.toNamed(Routes.SETTINGS); // فتح SettingsView
  }

  // فتح صفحة الإشعارات
  void openNotifications() {
    Get.snackbar("Notifications", "فتح صفحة الإشعارات");
  }

  // فتح صفحة حول التطبيق
  void openAbout() {
    Get.snackbar("About", "فتح صفحة حول التطبيق");
  }
}
