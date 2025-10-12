import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/product_section_model.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/api/api_service.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductDetailsController extends GetxController {
  final CartController cartController = Get.find();

  var product = Rxn<ProductModel>();
  var cards = <ProductSectionModel>[].obs;
  var isLoading = false.obs;
  var isDescriptionExpanded = false.obs;

  RxInt orderQuantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ProductModel) {
      product.value = Get.arguments as ProductModel;
      final initialQty = product.value?.orderQuantity ?? 1;
      orderQuantity.value = initialQty > 0 ? initialQty : 1;
      fetchProductDetails();
    }
  }

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  Future<void> fetchProductDetails() async {
    if (product.value == null) return;
    try {
      isLoading.value = true;
      final detailedProduct =
          await ApiService.getProductById(product.value!.productId.toString());
      product.value = detailedProduct;
      final fetchedQty = detailedProduct.orderQuantity;
      orderQuantity.value = fetchedQty > 0 ? fetchedQty : 1;
      cards.assignAll([]);
    } catch (e) {
      debugPrint("❌ Error fetching product details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🛒 إضافة المنتج للسلة
  Future<void> addToCart() async {
    final p = product.value;
    if (p == null) return;

    final token = MySharedPref.getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يجب تسجيل الدخول أولاً لإضافة منتجات إلى السلة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    final quantityToAdd = orderQuantity.value > 0 ? orderQuantity.value : 1;
    p.orderQuantity = quantityToAdd;

    final cartItem = CartDetail(
      cartDetailId: 0,
      productId: p.productId,
      productName: p.productName,
      description: p.description ?? '',
      imageUrl: p.productMainImageUrl ?? '',
      productVariantId: 0,
      quantity: quantityToAdd,
      unitPrice: p.discountedPrice ?? p.price ?? 0.0,
      taxAmount: 0.0,
      discountAmount:
          (p.price ?? 0.0) - (p.discountedPrice ?? p.price ?? 0.0),
      total: (p.discountedPrice ?? p.price ?? 0.0) * quantityToAdd,
      options: const [],
      note: '',
    );

    try {
      await cartController.addProductApi(cartItem);
      cartController.products.refresh();

      Get.snackbar(
        'تمت الإضافة!',
        'تمت إضافة المنتج "${p.productName}" إلى السلة 🛒',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint("❌ Failed to add product to API: $e");
      Get.snackbar(
        'خطأ',
        'فشل إضافة المنتج للسلة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  /// ⬆️ زيادة الكمية
  Future<void> increaseQuantity() async {
    final p = product.value;
    if (p == null) return;

    orderQuantity.value++;
    final cartItem = CartDetail(
      cartDetailId: 0,
      productId: p.productId,
      productName: p.productName,
      description: p.description ?? '',
      imageUrl: p.productMainImageUrl ?? '',
      productVariantId: 0,
      quantity: 1,
      unitPrice: p.discountedPrice ?? p.price ?? 0.0,
      taxAmount: 0.0,
      discountAmount:
          (p.price ?? 0.0) - (p.discountedPrice ?? p.price ?? 0.0),
      total: (p.discountedPrice ?? p.price ?? 0.0),
      options: const [],
      note: '',
    );

    try {
      await cartController.increaseQuantityApi(cartItem);
    } catch (e) {
      debugPrint("❌ Failed to increase quantity via API: $e");
    }
  }

  /// ⬇️ تقليل الكمية
  Future<void> decreaseQuantity() async {
    final p = product.value;
    if (p == null || orderQuantity.value <= 1) return;

    final cartItem = CartDetail(
      cartDetailId: 0,
      productId: p.productId,
      productName: p.productName,
      description: p.description ?? '',
      imageUrl: p.productMainImageUrl ?? '',
      productVariantId: 0,
      quantity: 1,
      unitPrice: p.discountedPrice ?? p.price ?? 0.0,
      taxAmount: 0.0,
      discountAmount:
          (p.price ?? 0.0) - (p.discountedPrice ?? p.price ?? 0.0),
      total: (p.discountedPrice ?? p.price ?? 0.0),
      options: const [],
      note: '',
    );

    try {
      await cartController.decreaseQuantityApi(cartItem);
      if (orderQuantity.value > 1) orderQuantity.value--;
    } catch (e) {
      debugPrint("❌ Failed to decrease quantity via API: $e");
    }
  }
}
