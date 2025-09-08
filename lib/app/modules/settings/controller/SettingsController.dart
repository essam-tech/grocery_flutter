import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/ProfileModel.dart';
import '../../../data/api/api_service.dart';
import '../../../data/local/my_shared_pref.dart';

class SettingsController extends GetxController {
  var profile = Rxn<profileModel>();
  var isLoading = false.obs;

  // TextEditingControllers
  late final TextEditingController firstNameCtrl;
  late final TextEditingController lastNameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController phoneCtrl;

  // الصورة المختارة
  var pickedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    firstNameCtrl = TextEditingController();
    lastNameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    fetchProfile();
  }

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }

  /// جلب بيانات البروفايل
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      // استخدم await لجلب التوكن
      final token = await MySharedPref.getToken() ?? "";
      if (token.isEmpty) return;

      final p = await ApiService.getProfile(token);
      profile.value = p;

      firstNameCtrl.text = p.firstName;
      lastNameCtrl.text = p.lastName;
      emailCtrl.text = p.email;
      phoneCtrl.text = p.phone;
    } catch (e) {
      print("خطأ: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// حفظ/تعديل بيانات البروفايل + رفع الصورة
  Future<void> saveProfile() async {
    isLoading.value = true;
    try {
      final token = await MySharedPref.getToken() ?? "";
      if (token.isEmpty) return;

      final firstName = firstNameCtrl.text.trim();
      final lastName = lastNameCtrl.text.trim();
      final email = emailCtrl.text.trim();
      final phone = phoneCtrl.text.trim();

      if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || phone.isEmpty) return;

      String? uploadedImageUrl;

      // رفع الصورة إذا تم اختيارها
      if (pickedImage.value != null) {
        uploadedImageUrl = await ApiService.uploadProfileImage(token, pickedImage.value!);
      }

      final success = await ApiService.updateProfile(
        token: token,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );

      if (success) {
        profile.value = profile.value?.copyWith(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          avatarUrl: uploadedImageUrl ?? profile.value?.avatarUrl,
        );
      }
    } catch (e) {
      print("خطأ: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// اختيار صورة جديدة من المعرض
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (image != null) pickedImage.value = File(image.path);
    } catch (e) {
      print("خطأ أثناء اختيار الصورة: $e");
    }
  }
}
