import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/api/api_service.dart';
import '../../base/controllers/base_controller.dart';
import '../../../components/custom_snackbar.dart';

class CartController extends GetxController {

  // قائمة المنتجات الموجودة في الكارت
  List<ProductModel> products = [];

  @override
  void onInit() {
    getCartProducts();
    super.onInit();
  }

  /// جلب منتجات الكارت من الـ API
  Future<void> getCartProducts() async {
    try {
      var allProducts = await ApiService.getHomePageProducts();
      // فلتر المنتجات حسب الكمية المطلوبة من قبل الزبون
      products = allProducts.where((p) => p.orderQuantity > 0).toList();
      update();
    } catch (e) {
      print("Error fetching cart products: $e");
    }
  }

  /// عند الضغط على "Purchase Now"
  Future<void> onPurchaseNowPressed() async {
    await clearCart();
    Get.back();
    CustomSnackBar.showCustomSnackBar(
      title: 'Purchased',
      message: 'Order placed successfully'
    );
  }

  /// مسح الكارت وإعادة تعيين الكميات
  Future<void> clearCart() async {
    try {
      var allProducts = await ApiService.getHomePageProducts();
      for (var p in allProducts) {
        p.orderQuantity = 0;
      }
      // تحديث عداد الكارت في BaseController
      if (Get.isRegistered<BaseController>()) {
        Get.find<BaseController>().getCartItemsCount();
      }
      // إعادة تحميل الكارت
      products = [];
      update();
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  /// زيادة كمية منتج معين
  void increaseQuantity(ProductModel product) {
    product.orderQuantity++;
    updateCart();
  }

  /// تقليل كمية منتج معين
  void decreaseQuantity(ProductModel product) {
    if (product.orderQuantity > 0) {
      product.orderQuantity--;
      updateCart();
    }
  }

  /// تحديث الكارت وعداد الكارت
  void updateCart() {
    if (Get.isRegistered<BaseController>()) {
      Get.find<BaseController>().getCartItemsCount();
    }
    getCartProducts();
  }
}
