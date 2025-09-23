import 'package:get/get.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../data/models/product_model.dart';
import '../../../data/api/api_service.dart';
import '../../../data/local/my_shared_pref.dart';

class BaseController extends GetxController {
  /// Current screen index
  RxInt currentIndex = 0.obs;

  /// Number of items in the cart
  RxInt cartItemsCount = 0.obs;

  /// All products for home page
  RxList<ProductModel> allProducts = <ProductModel>[].obs;

  /// Logged-in user data
  RxInt loggedInCustomerId = 0.obs;
  RxString loggedInToken = ''.obs;
  RxString loggedInPhone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Load user data from local storage
    loggedInCustomerId.value = MySharedPref.getUserId() ?? 0;
    loggedInToken.value = MySharedPref.getToken() ?? '';
    loggedInPhone.value = MySharedPref.getPhone() ?? '';

    // Fetch products
    getAllProducts();

    // Observe CartController if registered
    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      ever(cartController.products, (_) {
        updateCartCount(cartController);
      });
    }
  }

  /// Change current screen
  void changeScreen(int index) {
    currentIndex.value = index;
  }

  /// Fetch all products from API
  Future<void> getAllProducts() async {
    try {
      final products = await ApiService.getHomePageProducts();
      allProducts.assignAll(products);
      updateCartCountFromProducts();
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  /// Update cart count from CartController
  void updateCartCount(CartController cartController) {
    cartItemsCount.value = cartController.totalItems;
  }

  /// Update cart count from local products (fallback)
  void updateCartCountFromProducts() {
    cartItemsCount.value = allProducts.fold<int>(
      0,
      (prev, p) => prev + p.orderQuantity,
    );
  }

  /// Increase product quantity
  void increaseProductQuantity(int productId) {
    final product = allProducts.firstWhereOrNull((p) => p.productId == productId);
    if (product != null) {
      product.orderQuantity += 1;
      updateCartCountFromProducts();
      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().products.refresh();
      }
    } else {
      print("Product with id $productId not found.");
    }
  }

  /// Decrease product quantity
  void decreaseProductQuantity(int productId) {
    final product = allProducts.firstWhereOrNull((p) => p.productId == productId);
    if (product != null && product.orderQuantity > 0) {
      product.orderQuantity -= 1;
      updateCartCountFromProducts();
      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().products.refresh();
      }
    }
  }
}
