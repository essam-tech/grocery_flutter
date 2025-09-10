// ===== ProductDetailsView =====
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_card.dart';
import '../../../components/product_count_item_for_product.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // ===== الهيدر مع الصورة =====
            SizedBox(
              height: 330.h,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primaryColor.withOpacity(0.6),
                            theme.cardColor.withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  // أزرار التحكم
                  Positioned(
                    top: 24.h,
                    left: 24.w,
                    right: 24.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _glassIconButton(
                          onTap: () => Get.back(),
                          icon: Constants.backArrowIcon,
                        ),
                        _glassIconButton(
                          onTap: () {},
                          icon: Constants.searchIcon,
                        ),
                      ],
                    ),
                  ),
                  // صورة المنتج مع Hero
                  Positioned(
                    top: 80.h,
                    left: 0,
                    right: 0,
                    child: Obx(() {
                      final product = controller.product.value;
                      if (product == null) return const SizedBox();
                      return Hero(
                        tag: product.productId,
                        child: (product.productMainImageUrl?.isNotEmpty ?? false)
                            ? Image.network(
                                product.productMainImageUrl!,
                                width: 250.w,
                                height: 225.h,
                                fit: BoxFit.contain,
                              ).animate().fade().scale(
                                    duration: 800.ms,
                                    curve: Curves.fastOutSlowIn,
                                  )
                            : Container(
                                width: 250.w,
                                height: 225.h,
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported, size: 40.sp),
                              ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // ===== تفاصيل المنتج =====
            30.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() {
                final product = controller.product.value;
                if (product == null) return const SizedBox();
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.productName,
                        style: theme.textTheme.displayMedium,
                      ).animate().fade().slideX(
                            duration: 300.ms,
                            begin: -1,
                            curve: Curves.easeInSine,
                          ),
                    ),
                    ProductCountItemForProduct(product: product).animate().fade(duration: 200.ms),
                  ],
                );
              }),
            ),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() {
                final product = controller.product.value;
                if (product == null) return const SizedBox();
                return Text(
                  '${product.discountedPrice ?? product.price} ${product.currencySymbol ?? '\$'}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fade().slideX(
                      duration: 300.ms,
                      begin: -1,
                      curve: Curves.easeInSine,
                    );
              }),
            ),

            // ===== وصف المنتج مع Read more =====
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Obx(() {
                final product = controller.product.value;
                if (product == null) return const SizedBox();
                final isExpanded = controller.isDescriptionExpanded.value;
                final description = product.description ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge,
                    ).animate().fade().slideX(
                          duration: 300.ms,
                          begin: -1,
                          curve: Curves.easeInSine,
                        ),
                    if (description.length > 100)
                      TextButton(
                        onPressed: controller.toggleDescription,
                        child: Text(
                          isExpanded ? "Read less" : "Read more",
                          style: TextStyle(color: theme.primaryColor),
                        ),
                      ),
                  ],
                );
              }),
            ),

            // ===== البطاقات =====
            20.verticalSpace,
            Obx(() {
              if (controller.cards.isEmpty) return const SizedBox();
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    mainAxisExtent: 80.h,
                  ),
                  itemCount: controller.cards.length,
                  itemBuilder: (context, index) {
                    final card = controller.cards[index];
                    return CustomCard(
                      title: card.title ?? '',
                      subtitle: card.subtitle ?? '',
                      icon: card.icon ?? '',
                    );
                  },
                ).animate().fade().slideY(
                      duration: 300.ms,
                      begin: 1,
                      curve: Curves.easeInSine,
                    ),
              );
            }),

            // ===== زر إضافة للسلة =====
            30.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomButton(
                text: '🛒 Add to Cart',
                onPressed: () {
                  final product = controller.product.value;
                  if (product != null) {
                    product.orderQuantity = controller.orderQuantity.value;
                    controller.addToCart();
                  }
                },
                fontSize: 16.sp,
                radius: 50.r,
                verticalPadding: 16.h,
                hasShadow: true,
              ).animate().fade().slideY(
                    duration: 300.ms,
                    begin: 1,
                    curve: Curves.easeInSine,
                  ),
            ),
            30.verticalSpace,
          ],
        ),
      ),
    );
  }

  // زر دائري زجاجي للأيقونات
  Widget _glassIconButton({required VoidCallback onTap, required String icon}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            fit: BoxFit.none,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
