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

    final softGreen = const Color(0xFF40DF9F); // اللون الأخضر الهادئ

    return Obx(() {
      final isDark = !controller.isLightTheme.value;

      return DarkTransition(
        offset: Offset(context.width, -1),
        isDark: isDark,
        builder: (context, _) => Scaffold(
          backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
          body: Stack(
            children: [
              // خلفية Gradient Header بسيطة بدون الأخضر
              Container(
                height: 200.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.grey[900]!, Colors.grey[800]!]
                        : [Colors.white, Colors.grey[200]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30.r),
                  ),
                ),
              ),

              // المحتوى الرئيسي مع Refresh
              RefreshIndicator(
                color: softGreen,
                backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
                strokeWidth: 2.5,
                onRefresh: controller.refreshData,
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 60.h),

                    // Header مع البروفايل
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Obx(() {
                                final p = controller.profile.value;
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 26.r,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 24.r,
                                      backgroundImage: p?.avatarUrl != null
                                          ? NetworkImage(p!.avatarUrl!)
                                          : AssetImage(Constants.avatar) as ImageProvider,
                                    ),
                                  ),
                                );
                              }),
                              12.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome,',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14.sp,
                                      color: isDark ? Colors.white70 : Colors.grey[700],
                                    ),
                                  ),
                                  Obx(() {
                                    final p = controller.profile.value;
                                    return Text(
                                      p != null ? "${p.firstName} ${p.lastName}" : "Guest",
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                          CustomIconButton(
                            onPressed: controller.onChangeThemePressed,
                            backgroundColor: softGreen.withOpacity(0.15),
                            icon: Obx(() => Icon(
                                  controller.isLightTheme.value
                                      ? Icons.dark_mode_outlined
                                      : Icons.light_mode_outlined,
                                  color: softGreen,
                                  size: 22,
                                )),
                          ),
                        ],
                      ),
                    ),

                    20.verticalSpace,

                    // Search Bar مودرن باللمسة الخضراء فقط
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : Colors.white,
                          borderRadius: BorderRadius.circular(60.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: CustomFormField(
                          backgroundColor: Colors.transparent,
                          textSize: 14.sp,
                          hint: 'Search category',
                          hintFontSize: 14.sp,
                          hintColor: isDark ? Colors.white54 : Colors.grey[500],
                          maxLines: 1,
                          borderRound: 60.r,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                          focusedBorderColor: Colors.transparent,
                          isSearchField: true,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          prefixIcon: Container(
                            margin: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: softGreen.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(6.w),
                              child: SvgPicture.asset(
                                Constants.searchIcon,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onChanged: (value) => controller.searchProducts(value ?? ''),
                        ),
                      ),
                    ),

                    25.verticalSpace,

                    // Carousel مع لمسة خضراء خفيفة
                    if (controller.cards.isNotEmpty)
                      CarouselSlider.builder(
                        itemCount: controller.cards.length,
                        itemBuilder: (context, index, realIndex) {
                          final path = controller.cards[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(path, fit: BoxFit.cover),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.black26, Colors.transparent],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                                // لمسة خضراء بسيطة في الركن
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: Icon(Icons.star, color: softGreen, size: 24.sp),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 180.h,
                          viewportFraction: 0.85,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          enlargeCenterPage: true,
                        ),
                      ),

                    30.verticalSpace,

                    // Categories بدون Gradient الأخضر، فقط أيقونات خضراء
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        'Categories 😋',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    SizedBox(
                      height: 100.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[800] : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Icon(Icons.category, color: softGreen, size: 32.sp),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => 16.horizontalSpace,
                        itemCount: 5,
                      ),
                    ),

                    30.verticalSpace,

                    // Best Selling مع لمسات خضراء بسيطة
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Best Selling 🔥',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Icon(Icons.arrow_forward, color: softGreen),
                        ],
                      ),
                    ),
                    16.verticalSpace,

                    // Products Grid بدون Gradient الأخضر، فقط لمسات خضراء
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
                            mainAxisExtent: 220.h,
                          ),
                          itemBuilder: (context, index) {
                            final product = controller.filteredProducts[index];
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey[850] : Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ProductItem(product: product),
                                    // لمسة خضراء صغيرة على البطاقة
                                    Positioned(
                                      top: 8.h,
                                      right: 8.w,
                                      child: Icon(Icons.check_circle,
                                          color: softGreen, size: 20.sp),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    40.verticalSpace,
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
