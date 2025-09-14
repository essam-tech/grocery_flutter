import 'package:get/get.dart';
import '../../../data/models/cart_model.dart';

class CartController extends GetxController {
  // للوصول السهل من أي مكان
  static CartController get to => Get.find();

  // قائمة منتجات السلة
  var products = <CartDetail>[].obs;

  // 🔹 المبلغ الإجمالي كسطر Rx
  var totalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    print("ℹ️ CartController initialized");

    // تحديث المجموع تلقائي عند أي تغيير في المنتجات
    ever(products, (_) => _updateTotal());
  }

  void _updateTotal() {
    totalAmount.value = products.fold(0, (sum, item) => sum + item.total);
  }

  /// إضافة منتج جديد للكارت أو زيادة الكمية لو موجود
  void addProduct(CartDetail item) {
    final index = products.indexWhere((e) => e.productId == item.productId);
    if (index != -1) {
      products[index].quantity += item.quantity;
      products[index].total = products[index].unitPrice * products[index].quantity;
      print("ℹ️ Increased quantity for product: ${item.productName}, new qty: ${products[index].quantity}");
    } else {
      products.add(item);
      print("ℹ️ Added new product to cart: ${item.productName}");
    }
    products.refresh();
  }

  /// زيادة كمية منتج موجود في السلة
  void increaseQuantity(CartDetail item) {
    final index = products.indexWhere((e) => e.productId == item.productId);
    if (index != -1) {
      products[index].quantity++;
      products[index].total = products[index].unitPrice * products[index].quantity;
      products.refresh();
      print("ℹ️ Increased quantity: ${products[index].productName} = ${products[index].quantity}");
    }
  }

  /// تقليل كمية منتج موجود في السلة
  void decreaseQuantity(CartDetail item) {
    final index = products.indexWhere((e) => e.productId == item.productId);
    if (index != -1 && products[index].quantity > 1) {
      products[index].quantity--;
      products[index].total = products[index].unitPrice * products[index].quantity;
      products.refresh();
      print("ℹ️ Decreased quantity: ${products[index].productName} = ${products[index].quantity}");
    } else if (index != -1 && products[index].quantity == 1) {
      removeItem(products[index]);
    }
  }

  /// حذف منتج من السلة
  void removeItem(CartDetail item) {
    products.removeWhere((e) => e.productId == item.productId);
    products.refresh();
    print("❌ Removed product from cart: ${item.productName}");
  }

  /// مسح كل السلة
  void clearCart() {
    products.clear();
    print("ℹ️ Cart cleared");
  }

  /// إجمالي عدد المنتجات في السلة
  int get totalItems => products.fold(0, (sum, item) => sum + item.quantity);

  /// إجمالي سعر السلة (للاستخدام المباشر)
  double get totalPrice => totalAmount.value;
}
