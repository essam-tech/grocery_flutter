import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../components/product_count_item.dart';
import '../../../../data/models/product_model.dart';
import '../../controllers/cart_controller.dart';

class CartItem extends GetView<CartController> {
  final ProductModel product;
  const CartItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // استخدم Image.network بدل Image.asset، وفحص null
          product.productMainImageUrl != null && product.productMainImageUrl!.isNotEmpty
              ? Image.network(
                  product.productMainImageUrl!,
                  width: 50.w,
                  height: 40.h,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 50.w,
                  height: 40.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported, size: 20.sp),
                ),
          16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.productName, style: theme.textTheme.headlineSmall),
              5.verticalSpace,
              Text(
                product.discountedPrice != null
                    ? '${product.discountedPrice} ${product.currencySymbol} (${product.price ?? 0} ${product.currencySymbol})'
                    : '${product.price ?? 0} ${product.currencySymbol}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          ProductCountItem(product: product),
        ],
      ),
    );
  }
}
