import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/ProfileModel.dart';
import '../../../data/api/api_service.dart';
import '../../../../config/theme/my_theme.dart';
import '../../../data/local/my_shared_pref.dart';
import '../../../../utils/constants.dart';

class HomeController extends GetxController {
  // المنتجات
  var products = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;

  // بطاقات الهيدر (Carousel)
  var cards = [Constants.card1, Constants.card2, Constants.card3];

  // بيانات البروفايل
  var profile = Rxn<profileModel>();

  // ثيم التطبيق (observable لتحديث الواجهة)
  var isLightTheme = false.obs;

  @override
  void onInit() {
    super.onInit();
    initController();
  }

  /// --- تهيئة البيانات عند بداية التشغيل ---
  Future<void> initController() async {
    // جلب الثيم الحالي
    isLightTheme.value = await MySharedPref.getThemeIsLight();

    // جلب المنتجات
    await fetchProducts();

    // جلب بيانات البروفايل
    await fetchProfile();
  }

  /// --- جلب منتجات الصفحة الرئيسية ---
  Future<void> fetchProducts() async {
    try {
      final fetchedProducts =
          await ApiService.getHomePageProducts(pageSize: 10);
      products.assignAll(fetchedProducts);
      filteredProducts.assignAll(products); // مبدئيًا يعرضهم
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  /// --- البحث داخل المنتجات ---
  void searchProducts(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      filteredProducts.assignAll(products);
      return;
    }

    filteredProducts.assignAll(
      products.where((p) {
        final name = p.productName.toLowerCase();
        final desc = (p.description ?? '').toLowerCase();
        return name.contains(q) || desc.contains(q);
      }).toList(),
    );
  }

  /// --- تغيير الثيم ---
  Future<void> onChangeThemePressed() async {
    // تغيير الثيم من MyTheme
    MyTheme.changeTheme();

    // تحديث القيمة الحالية من SharedPref
    isLightTheme.value = await MySharedPref.getThemeIsLight();

    // تحديث الـ UI
    update(['Theme']);
  }

  /// --- تحديث البيانات ---
  Future<void> refreshData() async {
    await fetchProducts();
    await fetchProfile();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// --- جلب بيانات البروفايل ---
  Future<void> fetchProfile() async {
    try {
      final token = await MySharedPref.getToken(); // 🔑 انتبه لـ await
      if (token == null || token.isEmpty) return; // لو ما فيه توكن، نرجع

      final fetchedProfile = await ApiService.getProfile(token);
      profile.value = fetchedProfile;
      print("✅ جلب البروفايل ناجح: ${fetchedProfile.firstName}");
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }
}
