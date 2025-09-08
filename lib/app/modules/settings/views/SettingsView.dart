import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/SettingsController.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController ctrl = Get.put(SettingsController());

    return Scaffold(
      body: Stack(
        children: [
          // خلفية Gradient
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // صورة البروفايل مع تعديل
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: Obx(() {
                      final file = ctrl.pickedImage.value;
                      final url = ctrl.profile.value?.avatarUrl;
                      return Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.green[400],
                            backgroundImage: file != null
                                ? FileImage(file)
                                : (url != null ? NetworkImage(url) : null) as ImageProvider<Object>?,
                            child: (file == null && url == null)
                                ? const Icon(Icons.person, size: 50, color: Colors.white)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: ctrl.pickImage,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.green,
                                child: const Icon(Icons.edit, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  if (ctrl.isLoading.value)
                    const Center(child: CircularProgressIndicator(color: Colors.white))
                  else ...[
                    _buildTextField(ctrl.firstNameCtrl, Icons.person, "First Name"),
                    const SizedBox(height: 12),
                    _buildTextField(ctrl.lastNameCtrl, Icons.person, "Last Name"),
                    const SizedBox(height: 12),
                    _buildTextField(ctrl.emailCtrl, Icons.email, "Email"),
                    const SizedBox(height: 12),
                    _buildTextField(ctrl.phoneCtrl, Icons.phone, "Phone"),
                    const SizedBox(height: 30),
                    _buildActionButton(label: "Save", onPressed: ctrl.saveProfile),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, IconData icon, String label) {
    final isDark = Get.isDarkMode;
    return Card(
      color: isDark ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: ctrl,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            prefixIcon: Icon(icon, color: Colors.green),
          ),
        ),
      ),
    );
  }

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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(label, style: const TextStyle(fontSize: 16)),
          ),
        ));
  }
}
