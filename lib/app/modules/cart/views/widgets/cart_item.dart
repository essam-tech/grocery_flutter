import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../data/models/cart_model.dart';
import '../../controllers/cart_controller.dart';
import '../../../../components/product_count_item.dart';

class CartItem extends GetView<CartController> {
  final CartDetail product;

  const CartItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          product.imageUrl.isNotEmpty
              ? Image.network(product.imageUrl,
                  width: 50.w, height: 50.h, fit: BoxFit.cover)
              : Container(width: 50.w, height: 50.h, color: Colors.grey[300]),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.productName, style: theme.textTheme.headlineSmall),
                5.verticalSpace,
                Text('${product.unitPrice}', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          ProductCountItem(product: product),
        ],
      ),
    );
  }
}
