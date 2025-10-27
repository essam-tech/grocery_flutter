import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/ProfileModel.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  var isCodeHidden = true.obs;
  var isLoading = false.obs;
  var step = 0.obs; // 0=إرسال كود, 1=تحقق الكود, 2=استكمال التسجيل

  String? authToken;

  void toggleCodeVisibility() {
    isCodeHidden.value = !isCodeHidden.value;
    print("🔑 isCodeHidden: ${isCodeHidden.value}");
  }

  Future<void> sendVerificationCode() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return;

    isLoading.value = true;
    try {
      if (await ApiService.sendVerificationCode(email)) {
        step.value = 1;
        print("✅ Step 0: الكود تم إرساله، الانتقال للخطوة 1");
      }
    } catch (e) {
      print("❌ Step 0 Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyCode() async {
    final email = emailController.text.trim();
    final code = codeController.text.trim();
    if (email.isEmpty || code.isEmpty) return;

    isLoading.value = true;
    try {
      authToken = await ApiService.verifyCode(email, code);
      if (authToken != null) {
        await MySharedPref.setToken(authToken!,
            expiresIn: const Duration(minutes: 5)); // توكن قصير صالح 5 دقائق
        step.value = 2;
        print("✅ Step 1: التوكن القصير مستلم وحفظ في SharedPreferences");
      }
    } catch (e) {
      print("❌ Step 1 Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> completeRegistration() async {
    final email = emailController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();

    if ([email, firstName, lastName, phone].any((e) => e.isEmpty)) return false;
    if (authToken == null) return false;

    isLoading.value = true;
    try {
      final token = await ApiService.completeRegistration(
        token: authToken!,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (token.isNotEmpty) {
        await MySharedPref.setToken(token,
            expiresIn: const Duration(days: 30)); // توكن طويل
        authToken = token;
        print("✅ Step 2: التسجيل مكتمل والتوكن الطويل محفوظ");
        return true;
      }
    } catch (e) {
      print("❌ Step 2 Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<profileModel?> getProfile() async {
    try {
      final token = authToken ?? MySharedPref.getToken();
      if (token == null) return null;
      return await ApiService.getProfile(token);
    } catch (e) {
      print("❌ خطأ أثناء جلب البروفايل: $e");
      return null;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    print("🧹 Controllers disposed");
    super.onClose();
  }
}
