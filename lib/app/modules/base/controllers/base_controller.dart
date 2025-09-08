import 'package:get/get.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../data/models/product_model.dart';
import '../../../data/api/api_service.dart';

class BaseController extends GetxController {
  // current screen index
  int currentIndex = 0;

  // to count the number of products in the cart
  int cartItemsCount = 0;

  // قائمة كل المنتجات
  List<ProductModel> allProducts = [];

  @override
  void onInit() {
    getAllProducts();
    super.onInit();
  }

  /// تغيير الشاشة المحددة
  void changeScreen(int selectedIndex) {
    currentIndex = selectedIndex;
    update();
  }

  /// جلب كل المنتجات من الـ API وتحديث عداد الكارت
  Future<void> getAllProducts() async {
    try {
      allProducts = await ApiService.getHomePageProducts();
      getCartItemsCount();
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  /// حساب عدد المنتجات الموجودة في الكارت بشكل آمن
  void getCartItemsCount() {
    cartItemsCount = allProducts.fold<int>(
      0,
      (previousValue, element) => previousValue + (element.orderQuantity),
    );
    update(['CartBadge']);
  }

  /// زيادة كمية المنتج بشكل آمن
  void onIncreasePressed(int productId) {
    // نتحقق إذا المنتج موجود قبل استخدام firstWhere
    if (allProducts.any((p) => p.productId == productId)) {
      final product = allProducts.firstWhere((p) => p.productId == productId);
      product.orderQuantity = (product.orderQuantity) + 1;
      getCartItemsCount();

      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().getCartProducts();
      }
      update(['ProductQuantity']);
    } else {
      print("Product with id $productId not found in allProducts");
    }
  }

  /// تقليل كمية المنتج بشكل آمن
  void onDecreasePressed(int productId) {
    if (allProducts.any((p) => p.productId == productId)) {
      final product = allProducts.firstWhere((p) => p.productId == productId);
      if ((product.orderQuantity) > 0) {
        product.orderQuantity = product.orderQuantity - 1;
        getCartItemsCount();

        if (Get.isRegistered<CartController>()) {
          Get.find<CartController>().getCartProducts();
        }
        update(['ProductQuantity']);
      }
    } else {
      print("Product with id $productId not found in allProducts");
    }
  }
}
