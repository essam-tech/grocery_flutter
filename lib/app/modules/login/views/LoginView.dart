// ---------------- LoginView مودرن وهادئ ----------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/LoginController.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  // 🌿 ألوان هادئة
  final Color softGreen = const Color(0xFF40DF9F);
  final Color softGreenLight = const Color(0xFFA8E6CF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌿 خلفية Gradient هادئة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [softGreenLight, softGreen],
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
                      icon: Icon(Icons.arrow_back, color: softGreen, size: 28),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 👤 صورة افتراضية
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: softGreen,
                      child: const Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 📊 Progress Bar
                  LinearProgressIndicator(
                    value: (controller.step.value + 1) / 3,
                    backgroundColor: Colors.white54,
                    color: softGreen,
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
                    ),
                  ],

                  // ---------------- Step 2 ----------------
                  if (controller.step.value == 2) ...[
                    _buildTextField(controller.firstNameController, "First Name"),
                    const SizedBox(height: 12),
                    _buildTextField(controller.lastNameController, "Last Name"),
                    const SizedBox(height: 12),
                    _buildTextField(controller.phoneController, "Phone"),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      label: "Complete Registration",
                      onPressed: () async {
                        final done = await controller.completeRegistration();
                        if (done && !controller.isLoading.value) {
                          // ✅ Snackbar / Bottom Sheet فقط للعملية الأخيرة
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
                                  Icon(Icons.check_circle, color: softGreen, size: 60),
                                  const SizedBox(height: 12),
                                  Text(
                                    "تم استكمال التسجيل بنجاح",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: softGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "يمكنك الآن تسجيل الدخول واستعراض حسابك.",
                                    style: TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back(); // يغلق الـ bottom sheet
                                      Get.back(); // يعود للصفحة السابقة
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: softGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                    ),
                                    child: const Text("موافق", style: TextStyle(fontSize: 16, color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                            isDismissible: false,
                          );
                        }
                      },
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
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: "Email",
            prefixIcon: Icon(Icons.email, color: softGreen),
          ),
        ),
      ),
    );
  }

  // 🔑 حقل الكود
  Widget _buildCodeField() {
    return Obx(() => Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: controller.codeController,
              keyboardType: TextInputType.number,
              obscureText: controller.isCodeHidden.value,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: "Verification Code",
                prefixIcon: Icon(Icons.lock, color: softGreen),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isCodeHidden.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: controller.toggleCodeVisibility,
                  color: softGreen,
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
            prefixIcon: Icon(Icons.person, color: softGreen),
          ),
        ),
      ),
    );
  }

  // 🔘 زر الإجراء
  Widget _buildActionButton({
    required String label,
    required Function() onPressed,
  }) {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: softGreen,
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
