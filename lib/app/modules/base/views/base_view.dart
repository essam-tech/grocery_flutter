// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../routes/app_pages.dart';
import '../../calendar/views/calendar_view.dart';
import '../../category/views/category_view.dart';
import '../../profile/views/ProfileView.dart';
import '../controllers/base_controller.dart';
import '../../home/views/home_view.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({Key? key}) : super(key: key);

  final Color softGreen = const Color(0xFF40DF9F);
  final Color softGreenLight = const Color(0xFFA8E6CF);

  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return GetBuilder<BaseController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: controller.currentIndex,
            children: [
              HomeView(),
              CategoryView(),
              Center(),
              CalendarView(),
              ProfileView(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex,
          type: BottomNavigationBarType.fixed,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0.0,
          items: [
            _mBottomNavItem(
              label: 'Home',
              icon: Constants.homeIcon,
            ),
            _mBottomNavItem(
              label: 'Category',
              icon: Constants.categoryIcon,
            ),
            const BottomNavigationBarItem(
              label: '',
              icon: Center(),
            ),
            _mBottomNavItem(
              label: 'Calendar',
              icon: Constants.calendarIcon,
            ),
            _mBottomNavItem(
              label: 'Profile',
              icon: Constants.userIcon,
            ),
          ],
          onTap: controller.changeScreen,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          onPressed: () => Get.toNamed(Routes.CART),
          child: GetBuilder<BaseController>(
            id: 'CartBadge',
            builder: (_) => Badge(
              position: BadgePosition.bottomEnd(bottom: -16, end: 13),
              badgeContent: Text(
                controller.cartItemsCount.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              badgeStyle: BadgeStyle(
                elevation: 2,
                badgeColor: softGreen,
                borderSide: const BorderSide(color: Colors.white, width: 1),
              ),
              child: CircleAvatar(
                radius: 22.r,
                backgroundColor: softGreen,
                child: SvgPicture.asset(
                  Constants.cartIcon,
                  fit: BoxFit.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _mBottomNavItem({required String label, required String icon}) {
    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(icon, color: Get.isDarkMode ? Colors.white70 : Colors.black54),
      activeIcon: SvgPicture.asset(icon, color: softGreen),
    );
  }
}
