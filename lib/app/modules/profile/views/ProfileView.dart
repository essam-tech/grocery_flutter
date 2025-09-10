import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ProfileController.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final softGreen = const Color(0xFF40DF9F); // اللون الأخضر الهادئ

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      body: Stack(
        children: [
          // 🌿 خلفية gradient خضراء هادئة لمسات فقط
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  softGreen.withOpacity(0.6),
                  softGreen.withOpacity(0.3)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),

          // المحتوى
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).padding.top + 16,
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // صورة البروفايل واسم المستخدم
                Obx(() {
                  final profile = controller.profile.value;

                  final imageUrl = profile?.avatarUrl ?? '';
                  final displayName = profile != null
                      ? "${profile.firstName} ${profile.lastName}"
                      : "Guest User";

                  return CircleAvatar(
                    radius: 55,
                    backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: softGreen.withOpacity(0.6),
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : null,
                      child: imageUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  );
                }),

                const SizedBox(height: 15),

                // الاسم
                Obx(() {
                  final profile = controller.profile.value;
                  final displayName = profile != null
                      ? "${profile.firstName} ${profile.lastName}"
                      : "Guest User";
                  return Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  );
                }),

                const SizedBox(height: 25),

                // قائمة الخيارات
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 20),
                    children: [
                      _buildProfileCard(
                        icon: Icons.person,
                        title: "login",
                        onTap: () => controller.openProfileDetails(),
                        softGreen: softGreen,
                        theme: theme,
                      ),
                      _buildProfileCard(
                        icon: Icons.settings,
                        title: "profile settings",
                        onTap: () => controller.openSettings(),
                        softGreen: softGreen,
                        theme: theme,
                      ),
                      _buildProfileCard(
                        icon: Icons.notifications,
                        title: "Notifications",
                        onTap: () => controller.openNotifications(),
                        softGreen: softGreen,
                        theme: theme,
                      ),
                      _buildProfileCard(
                        icon: Icons.info,
                        title: "About",
                        onTap: () => controller.openAbout(),
                        softGreen: softGreen,
                        theme: theme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🟢 ويدجت الكروت بشكل عصري ومتناسق مع الوضع الليلي
  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color softGreen,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final iconBgColor =
        isDark ? softGreen.withOpacity(0.2) : softGreen.withOpacity(0.2);
    final textColor = softGreen;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      shadowColor: softGreen.withOpacity(0.3),
      color: cardColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconBgColor,
          child: Icon(icon, color: textColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: textColor),
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
