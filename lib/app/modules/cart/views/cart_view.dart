import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../../components/custom_button.dart';
import '../../../components/no_data.dart';
import 'widgets/cart_item.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Obx(() => Column(
            children: [
              20.verticalSpace,
              Expanded(
                child: controller.products.isEmpty
                    ? const NoData(text: "No Products in Your Cart")
                    : ListView.separated(
                        separatorBuilder: (_, __) => const Divider(),
                        itemCount: controller.products.length,
                        itemBuilder: (context, index) =>
                            CartItem(product: controller.products[index])
                                .animate()
                                .fade()
                                .slideX(duration: 300.ms, begin: -1),
                      ),
              ),
              20.verticalSpace,
              if (controller.products.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomButton(
                    text: "Purchase Now",
                    onPressed: () {
                      controller.clearCart();
                      Get.back();
                    },
                  ).animate().fade().slideY(duration: 300.ms, begin: 1),
                ),
              20.verticalSpace,
            ],
          )),
    );
  }
}
