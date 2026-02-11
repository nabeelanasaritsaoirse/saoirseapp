import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/order_card.dart';
import '../../widgets/write_review_dialog.dart';
import 'order_delivered_controller.dart';
import 'write_review_controller/write_review_controller.dart';

class OrderDeliveredScreen extends StatelessWidget {
  OrderDeliveredScreen({super.key});

  final OrderDeliveredController controller =
      Get.find<OrderDeliveredController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      //--------------------- APP BAR -----------------------
      appBar: CustomAppBar(
        title: "Delivered",
        showBack: true,
      ),
      //--------------------- BODY -----------------------
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: appLoader());
        }
        if (controller.orders.isEmpty) {
          return Center(
            child: appText(
              "No delivered orders found",
              fontSize: 16.sp,
              color: AppColors.textBlack,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(top: 7.h),
          itemCount: controller.orders.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.orders.length) {
              return controller.isPageLoading.value
                  ? Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: appLoader()),
                    )
                  : const SizedBox.shrink();
            }

            final order = controller.orders[index];
            final productId = order.productId;

            // 🔥 REACTIVE BLOCK
            return Obx(() {
              final eligibility = controller.reviewEligibility[productId];
              final canReview = eligibility?.canReview == true;

              return OrderCard(
                order: order,
                showReviewButton: canReview,
                onWriteReview: canReview
                    ? () async {
                        Get.put(
                          WriteReviewController(productId: productId),
                          tag: productId,
                        );

                        final result = await Get.dialog(
                          WriteReviewDialog(productId: productId),
                          barrierDismissible: false,
                        );

                        if (result == true) {
                          controller.fetchDeliveredOrders();

                          appToaster(content: "Review added successfully");
                        }
                      }
                    : null,
              );
            });
          },
        );
      }),
    );
  }
}
