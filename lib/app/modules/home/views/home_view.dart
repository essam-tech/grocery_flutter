import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_form_field.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/dark_transition.dart';
import '../../../components/product_item.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Obx(() {
      final isDark = !controller.isLightTheme.value; // استخدام .value مع RxBool

      return DarkTransition(
        offset: Offset(context.width, -1),
        isDark: isDark,
        builder: (context, _) => Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              // خلفية SVG
              Positioned(
                top: -100.h,
                child: SvgPicture.asset(
                  Constants.container,
                  fit: BoxFit.fill,
                  color: theme.canvasColor,
                ),
              ),

              // المحتوى الرئيسي مع سحب للتحديث
              RefreshIndicator(
                color: Colors.green,
                backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                strokeWidth: 2.5,
                onRefresh: controller.refreshData,
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    // Header مع بيانات البروفايل
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Welcome',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        subtitle: Obx(() {
                          final p = controller.profile.value;
                          return Text(
                            p != null ? "${p.firstName} ${p.lastName}" : "Guest",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          );
                        }),
                        leading: Obx(() {
                          final p = controller.profile.value;
                          return CircleAvatar(
                            radius: 22.r,
                            backgroundColor: theme.primaryColorDark,
                            child: ClipOval(
                              child: p?.avatarUrl != null
                                  ? Image.network(p!.avatarUrl!, fit: BoxFit.cover)
                                  : Image.asset(Constants.avatar, fit: BoxFit.cover),
                            ),
                          );
                        }),
                        trailing: CustomIconButton(
                          onPressed: () => controller.onChangeThemePressed(),
                          backgroundColor: theme.primaryColorDark,
                          icon: Obx(() => Icon(
                                controller.isLightTheme.value
                                    ? Icons.dark_mode_outlined
                                    : Icons.light_mode_outlined,
                                color: theme.appBarTheme.iconTheme?.color,
                                size: 20,
                              )),
                        ),
                      ),
                    ),

                    10.verticalSpace,

                    // Search Bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomFormField(
                        backgroundColor: isDark ? Colors.grey[800]! : theme.primaryColorDark,
                        textSize: 14.sp,
                        hint: 'Search category',
                        hintFontSize: 14.sp,
                        hintColor: isDark ? Colors.white54 : theme.hintColor,
                        maxLines: 1,
                        borderRound: 60.r,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                        focusedBorderColor: Colors.transparent,
                        isSearchField: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        prefixIcon: SvgPicture.asset(Constants.searchIcon, fit: BoxFit.none),
                        onChanged: (value) => controller.searchProducts(value!),
                      ),
                    ),

                    20.verticalSpace,

                    // Carousel
                    if (controller.cards.isNotEmpty)
                      SizedBox(
                        height: 158.h,
                        child: CarouselSlider.builder(
                          itemCount: controller.cards.length,
                          itemBuilder: (context, index, realIndex) {
                            final path = controller.cards[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.asset(path, fit: BoxFit.cover),
                            );
                          },
                          options: CarouselOptions(
                            viewportFraction: 0.9,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            enlargeCenterPage: true,
                          ),
                        ),
                      ),

                    20.verticalSpace,

                    // Categories Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        'Categories 😋',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    SizedBox(
                      height: 80.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        itemBuilder: (context, index) {
                          return Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Text(
                                'Empty',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => 12.horizontalSpace,
                        itemCount: 5,
                      ),
                    ),

                    20.verticalSpace,

                    // Best Selling Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Best selling 🔥',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            'See all',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,

                    // Best Selling Products Grid
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Obx(() {
                        if (controller.products.isEmpty) {
                          return Center(
                            child: Text(
                              "No Products Found",
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.filteredProducts.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 16.h,
                            mainAxisExtent: 200.h,
                          ),
                          itemBuilder: (context, index) => ProductItem(
                            product: controller.filteredProducts[index],
                          ),
                        );
                      }),
                    ),

                    30.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
