import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/product_section_model.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductDetailsController extends GetxController {
  final CartController cartController = Get.find();

  var product = Rxn<ProductModel>();
  var cards = <ProductSectionModel>[].obs; // ⚡ تعريف cards
  var isLoading = false.obs;
  var isDescriptionExpanded = false.obs;
  RxInt orderQuantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ProductModel) {
      product.value = Get.arguments as ProductModel;
      orderQuantity.value = product.value?.orderQuantity ?? 1;
    }
  }

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  Future<void> addToCart() async {
    final p = product.value;
    if (p == null) return;

    if ((p.variants?.isNotEmpty ?? false) &&
        (p.selectedVariantId == null || p.selectedVariantId == 0)) {
      Get.snackbar(
        'تنبيه',
        'الرجاء اختيار نوع المنتج قبل الإضافة إلى السلة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    final token = MySharedPref.getToken();
    if (token == null || token.isEmpty) return;

    final cartItem = CartDetail(
      cartDetailId: 0,
      productId: p.productId,
      productName: p.productName,
      description: p.description ?? '',
      imageUrl: p.productMainImageUrl ?? '',
      productVariantId: p.selectedVariantId ?? 0,
      quantity: orderQuantity.value > 0 ? orderQuantity.value : 1,
      unitPrice: p.discountedPrice ?? p.price ?? 0.0,
      taxAmount: 0.0,
      discountAmount: (p.price ?? 0.0) - (p.discountedPrice ?? p.price ?? 0.0),
      total: (p.discountedPrice ?? p.price ?? 0.0) *
          (orderQuantity.value > 0 ? orderQuantity.value : 1),
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
      productVariantId: p.selectedVariantId ?? 0,
      quantity: 1,
      unitPrice: p.discountedPrice ?? p.price ?? 0.0,
      taxAmount: 0.0,
      discountAmount: (p.price ?? 0.0) - (p.discountedPrice ?? p.price ?? 0.0),
      total: p.discountedPrice ?? p.price ?? 0.0,
      options: const [],
      note: '',
    );

    await cartController.increaseQuantityApi(cartItem);
  }

  Future<void> decreaseQuantity() async {
    final p = product.value;
    if (p == null || orderQuantity.value <= 1) return;

    orderQuantity.value--;

    final cartItem = CartDetail(
      cartDetailId: 0,
      productId: p.productId,
      productName: p.productName,
      description: p.description ?? '',
      imageUrl: p.productMainImageUrl ?? '',
      productVariantId: p.selectedVariantId ?? 0,
      quantity: 1,
      unitPrice: p.discountedPrice ?? p.price ?? 0.0,
      taxAmount: 0.0,
      discountAmount: (p.price ?? 0.0) - (p.discountedPrice ?? p.price ?? 0.0),
      total: p.discountedPrice ?? p.price ?? 0.0,
      options: const [],
      note: '',
    );

    await cartController.decreaseQuantityApi(cartItem);
  }
}
