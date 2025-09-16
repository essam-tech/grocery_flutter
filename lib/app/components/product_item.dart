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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== صورة المنتج مع Hero =====
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Hero(
                  tag: product.productId, // لازم يكون unique
                  child: (product.productMainImageUrl?.isNotEmpty ?? false)
                      ? Image.network(
                          product.productMainImageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.broken_image,
                            size: 80.sp,
                            color: Colors.grey,
                          ),
                        )
                      : Icon(
                          Icons.image_not_supported,
                          size: 80.sp,
                          color: Colors.grey,
                        ),
                ),
              ),
            ),

            // ===== بيانات المنتج =====
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنتج
                  Text(
                    product.productName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.verticalSpace,

                  // السعر
                  Text(
                    '${product.discountedPrice ?? product.price ?? 0} ${product.currencySymbol ?? 'YER'}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  2.verticalSpace,

                  // حالة التوفر
                  Text(
                    (product.productQuantity ?? 0) > 0 ? "متوفر" : "غير متوفر",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: (product.productQuantity ?? 0) > 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
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
