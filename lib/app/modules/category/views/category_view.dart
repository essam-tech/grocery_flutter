import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/category_controller.dart';

class CategoryView extends StatelessWidget {
  final controller = Get.put(CategoryController());
  final TextEditingController searchController = TextEditingController();

  CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final softGreen = const Color(0xFF40DF9F);

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      body: Column(
        children: [
          // 🔹 Header ثابت (عنوان + بحث)
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12.h,
              left: 16.w,
              right: 16.w,
              bottom: 12.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Categories",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                12.verticalSpace,
                // 🔹 شريط البحث
                TextField(
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  onChanged: (value) => controller.searchProducts(value),
                ),
                12.verticalSpace,
                // 🔹 أزرار الفئات (ثابتة)
                CategoryButtons(controller: controller, softGreen: softGreen),
              ],
            ),
          ),

          // 🔹 منتجات تتحرك مع السكرول
          Expanded(
            child: RefreshIndicator(
              color: softGreen,
              onRefresh: () async => controller.fetchProductsAndCategories(),
              child: Obx(() {
                if (controller.filteredProducts.isEmpty) {
                  return Center(
                    child: Text(
                      "No Products Found",
                      style: TextStyle(
                        color: softGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    mainAxisExtent: 220.h,
                  ),
                  itemCount: controller.filteredProducts.length + 1, // ✅ عنصر فارغ في النهاية
                  itemBuilder: (context, index) {
                    if (index == controller.filteredProducts.length) {
                      return SizedBox(height: 100.h); // مساحة بعد آخر المنتجات
                    }

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

  const CategoryButtons({Key? key, required this.controller, required this.softGreen})
      : super(key: key);

  @override
  State<CategoryButtons> createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  String selectedCategoryId = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 55.h,
      child: Obx(() {
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(right: 32.w),
          scrollDirection: Axis.horizontal,
          itemCount: widget.controller.categories.length,
          separatorBuilder: (_, __) => 12.horizontalSpace,
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                constraints: BoxConstraints(minWidth: 90.w),
                decoration: BoxDecoration(
                  color: isSelected ? widget.softGreen : theme.cardColor,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: widget.softGreen.withOpacity(0.35),
                            blurRadius: 8,
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
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
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
