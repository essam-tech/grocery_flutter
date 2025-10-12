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

  void addProduct(CartDetail item) {
    final index = products.indexWhere((e) => e.productId == item.productId);
    if (index != -1) {
      products[index].quantity += item.quantity;
      products[index].total =
          products[index].unitPrice * products[index].quantity;
      print(
          "ℹ️ Increased quantity for product: ${item.productName}, new qty: ${products[index].quantity}");
    } else {
      products.add(item);
      print("ℹ️ Added new product to cart: ${item.productName}");
    }
    products.refresh();
  }

  /// 🛒 إضافة منتج للسلة عبر الـ API
  Future<void> addProductApi(CartDetail item) async {
    if (token.isEmpty) {
      refreshToken();
      if (token.isEmpty) {
        print("⚠️ Token not set. Cannot add product to API");
        return;
      }
    }

    try {
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

  Future<void> increaseQuantityApi(CartDetail item) async {
    if (token.isEmpty) refreshToken();
    if (token.isEmpty) return;

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

  Future<void> decreaseQuantityApi(CartDetail item) async {
    if (token.isEmpty) refreshToken();
    if (token.isEmpty) return;

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

  Future<void> removeItemApi(CartDetail item) async {
    if (token.isEmpty) refreshToken();
    if (token.isEmpty) return;

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

  void clearCart() {
    products.clear();
    print("ℹ️ Cart cleared");
  }

  int get totalItems => products.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => totalAmount.value;
}
