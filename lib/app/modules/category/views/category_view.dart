import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../routes/app_pages.dart';
import '../../../../utils/constants.dart';
import '../controllers/category_controller.dart';

class CategoryView extends StatelessWidget {
  CategoryView({super.key});

  final controller = Get.put(CategoryController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final softGreen = const Color(0xFF40DF9F); // اللون الأخضر الهادئ

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      body: Stack(
        children: [
          // 🔹 خلفية SVG هادئة
          Positioned(
            top: -120.h,
            left: -50.w,
            child: SvgPicture.asset(
              Constants.container,
              fit: BoxFit.cover,
              color: isDark ? Colors.grey[850] : Colors.white,
              width: context.width * 1.2,
            ),
          ),

          // 🔹 المحتوى
          RefreshIndicator(
            color: softGreen,
            onRefresh: () async => controller.fetchProductsAndCategories(),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                // 🔹 Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      SizedBox(width: 8.w),
                      Text(
                        "Categories",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 شريط البحث مع لمسة خضراء
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search, color: softGreen),
                      filled: true,
                      fillColor: isDark ? Colors.grey[850] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        controller.filterProducts(controller.selectedCategoryId.value);
                      } else {
                        controller.filteredProducts.assignAll(
                          controller.allProducts.where((p) =>
                              p.productName.toLowerCase().contains(value.toLowerCase()) &&
                              (controller.selectedCategoryId.value == 'all' ||
                                  p.categoryName == controller.selectedCategoryId.value)),
                        );
                      }
                    },
                  ),
                ),

                16.verticalSpace,

                // 🔹 أزرار الفئات مع لمسة خضراء
                CategoryButtons(controller: controller, softGreen: softGreen),
                16.verticalSpace,

                // 🔹 شبكة المنتجات
                Obx(() {
                  if (controller.filteredProducts.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100.h),
                        child: Text(
                          "No Products Found",
                          style: TextStyle(
                              color: softGreen,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: controller.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final ProductModel product = controller.filteredProducts[index];

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          color: isDark ? Colors.grey[850] : Colors.white,
                          elevation: 4,
                          shadowColor: softGreen.withOpacity(0.2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Image.network(
                                    product.productMainImageUrl ??
                                        'https://via.placeholder.com/150',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: theme.dividerColor,
                                      child: Icon(Icons.image,
                                          size: 60, color: theme.hintColor),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.productName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                        color: theme.textTheme.bodyMedium?.color,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    4.verticalSpace,
                                    Text(
                                      "${product.price} ${product.currencySymbol ?? '\$'}",
                                      style: TextStyle(
                                        color: softGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),

                30.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- CategoryButtons ----------------
class CategoryButtons extends StatefulWidget {
  final CategoryController controller;
  final Color softGreen;
  const CategoryButtons({super.key, required this.controller, required this.softGreen});

  @override
  State<CategoryButtons> createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  String selectedCategoryId = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 50.h,
      child: Obx(() {
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          scrollDirection: Axis.horizontal,
          itemCount: widget.controller.categories.length,
          separatorBuilder: (_, __) => 8.horizontalSpace,
          itemBuilder: (context, index) {
            final category = widget.controller.categories[index];
            final isSelected = selectedCategoryId == category.id;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategoryId = category.id;
                });
                widget.controller.filterProducts(category.id);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? widget.softGreen : theme.cardColor,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: widget.softGreen.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
