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
    super.onInit();
    getAllProducts();

    // ربط العدادات مع CartController
    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      // أي تغير في منتجات الكارت يحدث تحديث للعداد
      ever(cartController.products, (_) {
        getCartItemsCountFromCart(cartController);
      });
    }
  }

  /// تغيير الشاشة المحددة
  void changeScreen(int selectedIndex) {
    currentIndex = selectedIndex;
    update();
  }

  /// جلب كل المنتجات من الـ API
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
    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      cartItemsCount = cartController.totalItems;
    } else {
      cartItemsCount = allProducts.fold<int>(
        0,
        (previousValue, element) => previousValue + (element.orderQuantity),
      );
    }
    update(['CartBadge']);
  }

  /// تحديث العد من CartController مباشرة
  void getCartItemsCountFromCart(CartController cartController) {
    cartItemsCount = cartController.totalItems;
    update(['CartBadge']);
  }

  /// زيادة كمية المنتج بشكل آمن
  void onIncreasePressed(int productId) {
    if (allProducts.any((p) => p.productId == productId)) {
      final product = allProducts.firstWhere((p) => p.productId == productId);
      product.orderQuantity += 1;
      getCartItemsCount();

      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().products.refresh();
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
      if (product.orderQuantity > 0) {
        product.orderQuantity -= 1;
        getCartItemsCount();

        if (Get.isRegistered<CartController>()) {
          Get.find<CartController>().products.refresh();
        }
        update(['ProductQuantity']);
      }
    } else {
      print("Product with id $productId not found in allProducts");
    }
  }
}
