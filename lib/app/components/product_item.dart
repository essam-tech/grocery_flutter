import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../routes/app_pages.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: product.productMainImageUrl != null
                  ? Image.network(product.productMainImageUrl!, fit: BoxFit.cover)
                  : Icon(Icons.image_not_supported, size: 100),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.productName, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price ?? 0} ${product.currencySymbol ?? 'YER'}',
                    style: TextStyle(color: Colors.green),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.availability, // متوفر / غير متوفر
                    style: TextStyle(
                      color: (product.productQuantity ?? 0) > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
