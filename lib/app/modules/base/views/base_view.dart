import 'dart:ui';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../routes/app_pages.dart';
import '../../address/views/address_view.dart';
import '../../category/views/category_view.dart';
import '../../profile/views/ProfileView.dart';
import '../controllers/base_controller.dart';
import '../../home/views/home_view.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({Key? key}) : super(key: key);

  final Color softGreen = const Color(0xFF40DF9F);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: controller.currentIndex.value,
              children: [
                HomeView(),
                CategoryView(),
                Center(),
                AddressView(
                  customerId: controller.loggedInCustomerId.value,
                  token: controller.loggedInToken.value,
                  userPhone: controller.loggedInPhone.value,
                ),
                ProfileView(),
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 60,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: BottomNavigationBar(
                  currentIndex: controller.currentIndex.value,
                  type: BottomNavigationBarType.fixed,
                  elevation: 6,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: [
                    _mBottomNavItem(
                        label: 'Home', icon: Constants.homeIcon, index: 0),
                    _mBottomNavItem(
                        label: 'Category',
                        icon: Constants.categoryIcon,
                        index: 1),
                    const BottomNavigationBarItem(
                        label: '', icon: SizedBox.shrink()),
                    _mBottomNavItem(
                        label: 'Address', icon: Constants.calendarIcon, index: 3),
                    _mBottomNavItem(
                        label: 'Profile', icon: Constants.userIcon, index: 4),
                  ],
                  onTap: controller.changeScreen,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: softGreen.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              elevation: 2,
              backgroundColor: Colors.white.withOpacity(0.2),
              onPressed: () => Get.toNamed(Routes.CART),
              child: Obx(() => Badge(
                    position: BadgePosition.bottomEnd(bottom: -10, end: -4),
                    badgeContent: Text(
                      controller.cartItemsCount.value.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    badgeStyle: const BadgeStyle(
                      elevation: 1,
                      badgeColor: Colors.redAccent,
                    ),
                    child: SvgPicture.asset(
                      Constants.cartIcon,
                      color: Colors.white.withOpacity(0.95),
                      height: 24,
                    ),
                  )),
            ),
          ),
        ));
  }

  BottomNavigationBarItem _mBottomNavItem({
    required String label,
    required String icon,
    required int index,
  }) {
    bool isSelected = controller.currentIndex.value == index;
    return BottomNavigationBarItem(
      label: label,
      icon: Transform.scale(
        scale: isSelected ? 1.15 : 1.0,
        child: SvgPicture.asset(
          icon,
          color: isSelected ? softGreen : Colors.grey[700],
          height: 22,
        ),
      ),
      activeIcon: Transform.scale(
        scale: 1.15,
        child: SvgPicture.asset(
          icon,
          color: softGreen,
          height: 24,
        ),
      ),
    );
  }
}
