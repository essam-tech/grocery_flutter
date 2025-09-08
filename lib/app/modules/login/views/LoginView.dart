// ---------------- UserProfileView ----------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/LoginController.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌿 الخلفية Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 16,
            ),
            child: Obx(() {
              return Column(
                children: [
                  // 🔙 زر الرجوع
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 28),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 👤 صورة افتراضية
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green[400],
                      child: const Icon(Icons.person,
                          size: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 📊 Progress Bar
                  LinearProgressIndicator(
                    value: (controller.step.value + 1) / 3,
                    backgroundColor: Colors.white54,
                    color: Colors.green[800],
                    minHeight: 6,
                  ),
                  const SizedBox(height: 30),

                  // ---------------- Step 0 ----------------
                  if (controller.step.value == 0) ...[
                    _buildEmailField(),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      label: "Send Verification Code",
                      onPressed: controller.sendVerificationCode,
                      colorLevel: 700,
                    ),
                  ],

                  // ---------------- Step 1 ----------------
                  if (controller.step.value == 1) ...[
                    _buildEmailField(enabled: false),
                    const SizedBox(height: 16),
                    _buildCodeField(),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      label: "Verify Code",
                      onPressed: controller.verifyCode,
                      colorLevel: 700,
                    ),
                  ],

                  // ---------------- Step 2 ----------------
                  if (controller.step.value == 2) ...[
                    _buildTextField(
                        controller.firstNameController, "First Name"),
                    const SizedBox(height: 12),
                    _buildTextField(controller.lastNameController, "Last Name"),
                    const SizedBox(height: 12),
                    _buildTextField(controller.phoneController, "Phone"),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      label: "Complete Registration",
                      onPressed: () async {
                        await controller.completeRegistration();
                        if (!controller.isLoading.value) {
                          // ✅ Bottom Sheet منبثق بعد النجاح
                          Get.bottomSheet(
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: Colors.green, size: 60),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "تم استكمال التسجيل بنجاح",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back(); // يغلق BottomSheet
                                      Get.back(); // يرجع للصفحة السابقة
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 12),
                                    ),
                                    child: const Text("موافق",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                            isDismissible: false,
                          );
                          debugPrint(
                              "✅ تم التسجيل بنجاح - عرض BottomSheet والرجوع للصفحة السابقة");
                        }
                      },
                      colorLevel: 800,
                    ),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // 📨 حقل الايميل
  Widget _buildEmailField({bool enabled = true}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller.emailController,
          enabled: enabled,
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: "Email",
            prefixIcon: Icon(Icons.email, color: Colors.green),
          ),
        ),
      ),
    );
  }

  // 🔑 حقل الكود
  Widget _buildCodeField() {
    return Obx(() => Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: controller.codeController,
              obscureText: controller.isCodeHidden.value,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: "Verification Code",
                prefixIcon: const Icon(Icons.lock, color: Colors.green),
                suffixIcon: IconButton(
                  icon: Icon(controller.isCodeHidden.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: controller.toggleCodeVisibility,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ));
  }

  // 📝 حقول البيانات
  Widget _buildTextField(TextEditingController ctrl, String label) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            prefixIcon: const Icon(Icons.person, color: Colors.green),
          ),
        ),
      ),
    );
  }

  // 🔘 زر الإجراء
  Widget _buildActionButton({
    required String label,
    required Function() onPressed,
    int colorLevel = 700,
  }) {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[colorLevel],
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(label, style: const TextStyle(fontSize: 16)),
          ),
        ));
  }
}
