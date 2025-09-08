import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../data/api/api_service.dart';

class LoginController extends GetxController {
  // 📝 Controllers
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  // 💡 Observables
  var isCodeHidden = true.obs;
  var isLoading = false.obs;
  var step = 0.obs; // 0=إرسال كود, 1=تحقق الكود, 2=استكمال التسجيل

  // 🔑 Token بعد التحقق
  String? authToken;

  /// Toggle visibility for code
  void toggleCodeVisibility() {
    isCodeHidden.value = !isCodeHidden.value;
    print("🔑 isCodeHidden: ${isCodeHidden.value}");
  }

  /// Step 0: إرسال كود التحقق
  Future<void> sendVerificationCode() async {
    final email = emailController.text.trim();
    print("📩 Step 0: إرسال كود التحقق للبريد: $email");

    if (email.isEmpty) {
      print("⚠️ البريد الإلكتروني فارغ");
      return;
    }

    isLoading.value = true;
    try {
      if (await ApiService.sendVerificationCode(email)) {
        step.value = 1;
        print("✅ Step 0: الكود تم إرساله، الانتقال للخطوة 1");
      } else {
        print("❌ Step 0 Error: فشل إرسال الكود");
      }
    } catch (e) {
      print("❌ Step 0 Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 1: التحقق من الكود واستلام التوكن
  Future<void> verifyCode() async {
    final email = emailController.text.trim();
    final code = codeController.text.trim();
    print("🔐 Step 1: التحقق من الكود. البريد: $email, الكود: $code");

    if (email.isEmpty || code.isEmpty) {
      print("⚠️ البريد أو الكود فارغ");
      return;
    }

    isLoading.value = true;
    try {
      authToken = await ApiService.verifyCode(email, code);
      step.value = 2;
      print("✅ Step 1: التوكن مستلم: $authToken, الانتقال للخطوة 2");
    } catch (e) {
      print("❌ Step 1 Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 2: استكمال التسجيل النهائي وحفظ التوكن
  Future<bool> completeRegistration() async {
    final email = emailController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();

    print(
        "📝 Step 2: استكمال التسجيل. البريد: $email, الاسم: $firstName $lastName, الهاتف: $phone");

    if (email.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty) {
      print("⚠️ بعض البيانات فارغة");
      return false;
    }

    if (authToken == null) {
      print("⚠️ التوكن غير موجود");
      return false;
    }

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
        // حفظ التوكن في SharedPreferences
        await MySharedPref.setToken(token);
        print("✅ Step 2: التسجيل مكتمل بنجاح، التوكن تم حفظه: $token");
        return true;
      } else {
        print("❌ Step 2 Error: التوكن غير موجود بعد التسجيل");
        return false;
      }
    } catch (e) {
      print("❌ Step 2 Error: $e");
      return false;
    } finally {
      isLoading.value = false;
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
