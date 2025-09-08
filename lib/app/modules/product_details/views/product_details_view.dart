import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_card.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/product_count_item.dart';
import '../controllers/product_details_controller.dart';
import '../../../data/models/product_model.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // استقبل المنتج من الـ arguments مباشرة
    final product = Get.arguments as ProductModel;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 330.h,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      Constants.container,
                      fit: BoxFit.fill,
                      color: theme.cardColor,
                    ),
                  ),
                  Positioned(
                    top: 24.h,
                    left: 24.w,
                    right: 24.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          onPressed: () => Get.back(),
                          icon: SvgPicture.asset(
                            Constants.backArrowIcon,
                            fit: BoxFit.none,
                            color: theme.appBarTheme.iconTheme?.color,
                          ),
                        ),
                        CustomIconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            Constants.searchIcon,
                            fit: BoxFit.none,
                            color: theme.appBarTheme.iconTheme?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 80.h,
                    left: 0,
                    right: 0,
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
                  ),
                ],
              ),
            ),
            30.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
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
                  ProductCountItem(product: product).animate().fade(
                        duration: 200.ms,
                      ),
                ],
              ),
            ),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                ', ${product.discountedPrice ?? product.price} ${product.currencySymbol ?? '\$'}',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ).animate().fade().slideX(
                    duration: 300.ms,
                    begin: -1,
                    curve: Curves.easeInSine,
                  ),
            ),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                product.description ?? '',
                style: theme.textTheme.bodyLarge,
              ).animate().fade().slideX(
                    duration: 300.ms,
                    begin: -1,
                    curve: Curves.easeInSine,
                  ),
            ),
            20.verticalSpace,
            if (controller.cards.isNotEmpty)
              Padding(
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
              ),
            30.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomButton(
                text: 'Add to cart',
                onPressed: () => controller.onAddToCartPressed(),
                fontSize: 16.sp,
                radius: 50.r,
                verticalPadding: 16.h,
                hasShadow: false,
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
}
