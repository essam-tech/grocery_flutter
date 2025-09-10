// ===== ProductCountItemForProduct =====
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../data/models/product_model.dart';
import '../../utils/constants.dart';
import 'custom_icon_button.dart';

class ProductCountItemForProduct extends StatelessWidget {
  final ProductModel product;

  ProductCountItemForProduct({Key? key, required this.product}) : super(key: key);

  // Rx للكمية
  final RxInt orderQuantity = 0.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // مزامنة القيمة مع المودل
    orderQuantity.value = product.orderQuantity;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // زر النقصان
        CustomIconButton(
          width: 36.w,
          height: 36.h,
          onPressed: () {
            if (orderQuantity.value > 0) orderQuantity.value--;
          },
          icon: SvgPicture.asset(
            Constants.removeIcon,
            fit: BoxFit.none,
          ),
          backgroundColor: theme.primaryColor,
        ),
        8.horizontalSpace,

        // عرض الكمية مع Obx
        Flexible(
          child: Obx(
            () => Text(
              orderQuantity.value.toString(),
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        8.horizontalSpace,

        // زر الزيادة
        CustomIconButton(
          width: 36.w,
          height: 36.h,
          onPressed: () {
            orderQuantity.value++;
          },
          icon: SvgPicture.asset(
            Constants.addIcon,
            fit: BoxFit.none,
          ),
          backgroundColor: theme.primaryColor,
        ),
      ],
    );
  }
}
