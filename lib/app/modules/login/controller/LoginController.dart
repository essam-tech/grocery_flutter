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

  // ------------------ إرسال كود التحقق ------------------
  Future<void> sendVerificationCode() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      print("⚠️ البريد الإلكتروني فارغ");
      return;
    }

    isLoading.value = true;
    print("📩 Step 0: إرسال كود التحقق إلى $email");
    try {
      final success = await ApiService.sendVerificationCode(email);
      if (success) {
        step.value = 1;
        print("✅ تم إرسال الكود بنجاح، الانتقال إلى خطوة التحقق");
      }
    } catch (e) {
      print("❌ خطأ أثناء إرسال الكود: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ التحقق من الكود ------------------
  Future<void> verifyCode() async {
    final email = emailController.text.trim();
    final code = codeController.text.trim();

    if (email.isEmpty || code.isEmpty) {
      print("⚠️ البريد أو الكود فارغ");
      return;
    }

    isLoading.value = true;
    print("🔐 Step 1: التحقق من الكود ($code) للبريد $email");

    try {
      // ✅ التغيير الأساسي: إضافة userAgent
      final token = await ApiService.verifyCode(email, code);
      if (token.isNotEmpty) {
        authToken = token;
        await MySharedPref.setToken(token);
        step.value = 2;
        print("✅ التحقق ناجح وتم حفظ التوكن: $token");
      } else {
        print("❌ لم يتم استلام التوكن بعد التحقق");
      }
    } catch (e) {
      print("❌ خطأ أثناء التحقق من الكود: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ استكمال التسجيل ------------------
  Future<bool> completeRegistration() async {
    final email = emailController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();

    if ([email, firstName, lastName, phone].any((e) => e.isEmpty)) {
      print("⚠️ يرجى ملء جميع الحقول قبل المتابعة");
      return false;
    }

    if (authToken == null || authToken!.isEmpty) {
      print("⚠️ لا يوجد توكن متاح لاستكمال التسجيل");
      return false;
    }

    isLoading.value = true;
    print("📝 Step 2: استكمال التسجيل بـ $email - $firstName $lastName ($phone)");

    try {
      final newToken = await ApiService.completeRegistration(
        token: authToken!,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (newToken.isNotEmpty) {
        await MySharedPref.setToken(newToken);
        authToken = newToken;
        print("✅ تم استكمال التسجيل وتحديث التوكن بنجاح");
        return true;
      } else {
        print("❌ فشل استكمال التسجيل (التوكن فارغ)");
        return false;
      }
    } catch (e) {
      print("❌ خطأ أثناء استكمال التسجيل: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ جلب البروفايل ------------------
  Future<profileModel?> getProfile() async {
    try {
      final token = authToken ?? await MySharedPref.getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ لا يوجد توكن صالح لجلب البروفايل");
        return null;
      }

      final profile = await ApiService.getProfile(token);
      print("✅ تم جلب بيانات البروفايل بنجاح: ${profile.firstName}");
      return profile;
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
    print("🧹 تم التخلص من الـ Controllers");
    super.onClose();
  }
}
