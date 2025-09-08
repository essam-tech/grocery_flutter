import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/product_section_model.dart';
import '../../../data/api/api_service.dart';

class ProductDetailsController extends GetxController {
  /// المنتج الأساسي (بيانات عامة مثل الاسم والسعر والصورة)
  late ProductModel product;

  /// أقسام إضافية مرتبطة بالمنتج (مواصفات، صور إضافية، Variants .. إلخ)
  var cards = <ProductSectionModel>[].obs;

  /// حالة تحميل البيانات
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // المنتج يتم تمريره من الصفحة السابقة عن طريق arguments
    if (Get.arguments != null && Get.arguments is ProductModel) {
      product = Get.arguments as ProductModel;
      fetchProductDetails();
    } else {
      // إذا لم يمرر المنتج، اعمل redirect أو أعرض رسالة خطأ
      print("❌ No product passed to ProductDetailsController");
    }
  }

  /// جلب بيانات تفصيلية للمنتج من API (الوصف الكامل + صور + Variants + Sections)
  Future<void> fetchProductDetails() async {
    try {
      isLoading.value = true;

      // 🟢 1- جلب تفاصيل المنتج
      var detailedProduct =
          await ApiService.getProductById(product.productId.toString());
      product = detailedProduct;
    
      // 🟢 2- جلب الـ Sections / Cards الخاصة بالمنتج (ممكن لاحقاً إذا كان عندك API لها)
      // حالياً نخليها فاضية
      cards.assignAll([]);

    } catch (e) {
      print("❌ Error fetching product details: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// عند الضغط على زر "Add to Cart"
  void onAddToCartPressed() {
    // هنا تقدر تستخدم Service لعربة التسوق
    // CartService.addProduct(product);
    print("🛒 Add to cart pressed for product: ${product.productName}");
  }
}
