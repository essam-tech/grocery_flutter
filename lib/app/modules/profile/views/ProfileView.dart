import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ProfileController.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 🌿 خلفية gradient خضراء ثابتة
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade700, Colors.greenAccent.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),

          // المحتوى بدون SafeArea، مع Padding أعلى يعتمد على status bar
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: MediaQuery.of(context).padding.top + 16,
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // صورة البروفايل
                CircleAvatar(
                  radius: 55,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green[400],
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // العنوان (فارغ أو يمكن وضع اسم المستخدم)
                Text(
                  "",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 25),

                // قائمة الخيارات
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView(
                      children: [
                        _buildProfileCard(
                          icon: Icons.person,
                          title: "login",
                          onTap: () => controller.openProfileDetails(),
                          theme: theme,
                        ),
                        _buildProfileCard(
                          icon: Icons.settings,
                          title: "Settings",
                          onTap: () => controller.openSettings(),
                          theme: theme,
                        ),
                        _buildProfileCard(
                          icon: Icons.notifications,
                          title: "Notifications",
                          onTap: () => controller.openNotifications(),
                          theme: theme,
                        ),
                        _buildProfileCard(
                          icon: Icons.info,
                          title: "About",
                          onTap: () => controller.openAbout(),
                          theme: theme,
                        ),
                      ],
                    ),
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
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;
    final iconBgColor = isDark ? Colors.green.shade900 : Colors.green[50];
    final textColor = Colors.green;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      shadowColor: Colors.greenAccent.withOpacity(0.5),
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
