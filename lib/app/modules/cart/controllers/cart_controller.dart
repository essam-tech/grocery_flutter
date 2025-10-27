import 'package:get/get.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/api/api_service.dart';
import '../../../data/local/my_shared_pref.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();

  late String token;

  var products = <CartDetail>[].obs;
  var totalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    print("ℹ️ CartController initialized");

    token = MySharedPref.getToken() ?? '';
    print("ℹ️ Token loaded: $token");

    ever(products, (_) => _updateTotal());
  }

  void _updateTotal() {
    totalAmount.value = products.fold(0, (sum, item) => sum + item.total);
  }

  void refreshToken() {
    token = MySharedPref.getToken() ?? '';
  }

  /// ✅ التأكد من أن التوكن موجود وصالح
  bool _ensureToken() {
    refreshToken();
    if (token.isEmpty) {
      print("🚨 Token missing! Redirecting to login.");
      Get.offAllNamed('/login');
      return false;
    }
    return true;
  }

  // 🧺 إضافة منتج إلى السلة (محلياً)
  void addProduct(CartDetail item) {
    final index = products.indexWhere((e) => e.productId == item.productId);
    if (index != -1) {
      products[index].quantity += item.quantity;
      products[index].total =
          products[index].unitPrice * products[index].quantity;
    } else {
      products.add(item);
    }
    products.refresh();
  }

  // 🧩 إضافة منتج للسلة عبر الـ API
  Future<void> addProductApi(CartDetail item) async {
    if (!_ensureToken()) return;

    if (item.quantity <= 0) item.quantity = 1; // حماية من الكمية صفر

    try {
      print("🧾 Sending add-to-cart: ${item.toJson()}");
      print("🔑 Token used: $token");

      final addedItem = await ApiService.addCartItem(
        token: token,
        productId: item.productId,
        productVariantId: item.productVariantId,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        note: item.note,
      );

      if (addedItem != null) {
        addProduct(addedItem);
      } else {
        print("⚠️ addCartItem returned null, product not added");
      }
    } catch (e) {
      print("❌ Failed to add product to API: $e");
    }
  }

  // ⬆️ زيادة كمية منتج
  Future<void> increaseQuantityApi(CartDetail item) async {
    if (!_ensureToken()) return;

    try {
      await ApiService.addCartItem(
        token: token,
        productId: item.productId,
        productVariantId: item.productVariantId,
        quantity: 1,
        unitPrice: item.unitPrice,
        note: item.note,
      );
      increaseQuantityLocal(item);
    } catch (e) {
      print("❌ Failed to increase quantity via API: $e");
    }
  }

  void increaseQuantityLocal(CartDetail item) {
    final index = products.indexWhere((e) => e.productId == item.productId);
    if (index != -1) {
      products[index].quantity++;
      products[index].total =
          products[index].unitPrice * products[index].quantity;
      products.refresh();
    }
  }

  // ⬇️ تقليل الكمية
  Future<void> decreaseQuantityApi(CartDetail item) async {
    if (!_ensureToken()) return;

    try {
      await ApiService.deleteCartItem(
        token: token,
        cartDetailId: item.cartDetailId,
      );
      decreaseQuantityLocal(item);
    } catch (e) {
      print("❌ Failed to decrease quantity via API: $e");
    }
  }

  void decreaseQuantityLocal(CartDetail item) {
    final index = products.indexWhere((e) => e.productId == item.productId);
    if (index != -1 && products[index].quantity > 1) {
      products[index].quantity--;
      products[index].total =
          products[index].unitPrice * products[index].quantity;
      products.refresh();
    } else if (index != -1 && products[index].quantity == 1) {
      removeItem(item);
    }
  }

  // ❌ حذف منتج من السلة
  Future<void> removeItemApi(CartDetail item) async {
    if (!_ensureToken()) return;

    try {
      await ApiService.deleteCartItem(
        token: token,
        cartDetailId: item.cartDetailId,
      );
      removeItem(item);
    } catch (e) {
      print("❌ Failed to remove product via API: $e");
    }
  }

  void removeItem(CartDetail item) {
    products.removeWhere((e) => e.productId == item.productId);
    products.refresh();
  }

  // 🧹 مسح السلة بالكامل
  void clearCart() {
    products.clear();
    print("ℹ️ Cart cleared");
  }

  // 🧮 إحصائيات
  int get totalItems => products.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => totalAmount.value;
}
