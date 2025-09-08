import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/api/api_service.dart';

class CategoryController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var allProducts = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var selectedCategoryId = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductsAndCategories();
  }

  Future<void> fetchProductsAndCategories() async {
    try {
      // فئة All مبدئية
      categories.assignAll([
        CategoryModel(id: 'all', name: 'All', image: '', isDefault: true),
      ]);

      // --- جلب المنتجات ---
      final products = await ApiService.getHomePageProducts(pageSize: 10);
      allProducts.assignAll(products);

      // استخراج الكاتيجوريز من المنتجات
      final uniqueCategories =
          allProducts.map((p) => p.categoryName ?? 'غير معروف').toSet().toList();

      categories.addAll(uniqueCategories.map((name) => CategoryModel(
            id: name,
            name: name,
            image: '',
            isDefault: false,
          )));

      // عرض الكل مبدئيًا
      filterProducts('all');
    } catch (e) {
      print('Error fetching data from API: $e');
    }
  }

  void filterProducts(String categoryId) {
    selectedCategoryId.value = categoryId;

    if (categoryId == 'all') {
      filteredProducts.assignAll(allProducts);
    } else {
      filteredProducts.assignAll(
        allProducts.where((p) => p.categoryName == categoryId).toList(),
      );
    }
  }
}
