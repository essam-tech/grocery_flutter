import 'package:get/get.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/ProfileModel.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  // 🌟 بيانات البروفايل كـ Rx
  var profile = Rx<profileModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  /// تحميل البروفايل من آخر توكن محفوظ
  Future<void> _loadProfile() async {
    try {
      final token = await MySharedPref.getToken(); // ⚡ await هنا
      if (token != null && token.isNotEmpty) {
        final fetchedProfile = await ApiService.getProfile(token);
        profile.value = fetchedProfile;
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب البروفايل: $e");
    }
  }

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

  /// تحديث البروفايل بعد تعديل البيانات
  Future<void> refreshProfile() async {
    try {
      final token = await MySharedPref.getToken(); // ⚡ await هنا أيضاً
      if (token != null && token.isNotEmpty) {
        final fetchedProfile = await ApiService.getProfile(token);
        profile.value = fetchedProfile;
      }
    } catch (e) {
      print("❌ خطأ أثناء تحديث البروفايل: $e");
    }
  }
}
