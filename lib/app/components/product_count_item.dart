import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';
import '../modules/cart/controllers/cart_controller.dart';
import '../data/models/cart_model.dart';
import 'custom_icon_button.dart';

class ProductCountItem extends StatelessWidget {
  final CartDetail product;

  const ProductCountItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cartController = CartController.to;

    return Row(
      children: [
        CustomIconButton(
          width: 36.w,
          height: 36.h,
          onPressed: () => cartController.decreaseQuantityApi(product),
          icon: SvgPicture.asset(Constants.removeIcon, fit: BoxFit.none),
          backgroundColor: theme.cardColor,
        ),
        16.horizontalSpace,
        Obx(() {
          final index = cartController.products.indexWhere((e) => e.productId == product.productId);
          final qty = index != -1 ? cartController.products[index].quantity : product.quantity;
          return Text(qty.toString(), style: theme.textTheme.headlineMedium);
        }),
        16.horizontalSpace,
        CustomIconButton(
          width: 36.w,
          height: 36.h,
          onPressed: () => cartController.increaseQuantityApi(product),
          icon: SvgPicture.asset(Constants.addIcon, fit: BoxFit.none),
          backgroundColor: theme.primaryColor,
        ),
      ],
    );
  }
}
