import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/product_section_model.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/api/api_service.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductDetailsController extends GetxController {
  final CartController cartController = Get.find();

  var product = Rxn<ProductModel>();
  var cards = <ProductSectionModel>[].obs;
  var isLoading = false.obs;
  var isDescriptionExpanded = false.obs;

  // RxInt للكمية
  RxInt orderQuantity = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ProductModel) {
      product.value = Get.arguments as ProductModel;
      orderQuantity.value = product.value?.orderQuantity ?? 1; // تهيئة الكمية
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
      var detailedProduct = await ApiService.getProductById(product.value!.productId.toString());
      product.value = detailedProduct;
      orderQuantity.value = detailedProduct.orderQuantity; // تحديث الكمية بعد جلب التفاصيل
      cards.assignAll([]);
    } catch (e) {
      print("Error fetching product details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// إضافة منتج للسلة
  void addToCart() {
    final p = product.value;
    if (p == null) return;

    p.orderQuantity = orderQuantity.value; // تحديث كمية المنتج قبل الإضافة

    final cartItem = CartDetail(
      cartDetailId: 0,
      productId: p.productId,
      productName: p.productName,
      description: p.description ?? '',
      imageUrl: p.productMainImageUrl ?? '',
      productVariantId: 0,
      quantity: p.orderQuantity,
      unitPrice: p.discountedPrice ?? p.price ?? 0.0,
      taxAmount: 0.0,
      discountAmount: (p.price ?? 0.0) - (p.discountedPrice ?? p.price ?? 0.0),
      total: (p.discountedPrice ?? p.price ?? 0.0) * p.orderQuantity,
      options: [],
      note: '',
    );

    cartController.addProduct(cartItem);
    cartController.products.refresh();

    Get.snackbar(
      'تمت الإضافة!',
      'تم إضافة المنتج "${p.productName}" للسلة 🛒',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // الآن نستخدم RxInt مباشرة من الـ controller للزيادة والنقصان داخل الـ widget
  void increaseQuantity() => orderQuantity.value++;
  void decreaseQuantity() {
    if (orderQuantity.value > 1) orderQuantity.value--;
  }
}
