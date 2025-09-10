import 'dart:ui';
import 'package:flutter/material.dart' hide Badge;
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

  final Color softGreen = const Color(0xFF40DF9F); // اللون المختار

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
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
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex,
              type: BottomNavigationBarType.fixed,
              elevation: 8,
              backgroundColor: Colors.white.withOpacity(0.25),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                _mBottomNavItem(label: 'Home', icon: Constants.homeIcon, index: 0),
                _mBottomNavItem(label: 'Category', icon: Constants.categoryIcon, index: 1),
                const BottomNavigationBarItem(label: '', icon: SizedBox.shrink()),
                _mBottomNavItem(label: 'Calendar', icon: Constants.calendarIcon, index: 3),
                _mBottomNavItem(label: 'Profile', icon: Constants.userIcon, index: 4),
              ],
              onTap: controller.changeScreen,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: softGreen.withOpacity(0.6),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            elevation: 4,
            backgroundColor: Colors.white.withOpacity(0.25),
            onPressed: () => Get.toNamed(Routes.CART),
            child: GetBuilder<BaseController>(
              id: 'CartBadge',
              builder: (_) => Badge(
                position: BadgePosition.bottomEnd(bottom: -12, end: -6),
                badgeContent: Text(
                  controller.cartItemsCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                badgeStyle: const BadgeStyle(
                  elevation: 2,
                  badgeColor: Colors.redAccent,
                ),
                child: SvgPicture.asset(
                  Constants.cartIcon,
                  color: Colors.white.withOpacity(0.95),
                  height: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _mBottomNavItem({
    required String label,
    required String icon,
    required int index,
  }) {
    bool isSelected = controller.currentIndex == index;
    return BottomNavigationBarItem(
      label: label,
      icon: Transform.scale(
        scale: isSelected ? 1.2 : 1.0,
        child: SvgPicture.asset(
          icon,
          color: isSelected ? softGreen : Colors.grey[700], // واضح عند عدم الاختيار
          height: 26,
        ),
      ),
      activeIcon: Transform.scale(
        scale: 1.2,
        child: SvgPicture.asset(
          icon,
          color: softGreen,
          height: 28,
        ),
      ),
    );
  }
}
