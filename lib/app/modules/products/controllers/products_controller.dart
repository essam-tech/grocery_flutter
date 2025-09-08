import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/api/api_service.dart';

class ProductsController extends GetxController {
  // قائمة المنتجات
  var products = <ProductModel>[].obs;

  // حالة التحميل
  var isLoading = false.obs;

  // رسالة الخطأ
  var errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  /// جلب المنتجات من الـ API
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final fetchedProducts = await ApiService.getHomePageProducts();

      products.assignAll(fetchedProducts);

      // إزالة المنتج اللي id = 2 إذا موجود
      products.removeWhere((p) => p.productId == 2);
    } catch (e) {
      errorMessage.value = "فشل في جلب المنتجات 🚨: $e";
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
