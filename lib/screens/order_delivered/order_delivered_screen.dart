import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/order_delivered/write_review_controller/write_review_controller.dart';
import 'package:saoirse_app/widgets/write_review_dialog.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/order_card.dart';
import 'order_delivered_controller.dart';

class OrderDeliveredScreen extends StatelessWidget {
  OrderDeliveredScreen({super.key});

  final OrderDeliveredController controller =
      Get.find<OrderDeliveredController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      //--------------------- APP BAR -----------------------
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: appText(
          "Delivered",
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
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
        // return ListView.builder(
        //   padding: EdgeInsets.only(top: 7.h),
        //   itemCount: controller.orders.length + 1,
        //   itemBuilder: (context, index) {
        //     if (index == controller.orders.length) {
        //       return controller.isPageLoading.value
        //           ? Padding(
        //               padding: EdgeInsets.all(12),
        //               child: Center(child: appLoader()),
        //             )
        //           : const SizedBox.shrink();
        //     }
        //     final order = controller.orders[index];
        //     return OrderCard(
        //       order: order,
        //       showReviewButton: true,
        //       onWriteReview: () {
        //         // IMPORTANT: use PRODUCT ID, not order.id
        //         final productId = order.id;

        //         // create controller BEFORE dialog
        //         Get.put(
        //           WriteReviewController(productId: productId),
        //           tag: productId,
        //         );

        //         Get.dialog(
        //           WriteReviewDialog(productId: productId),
        //           barrierDismissible: false,
        //         );
        //       },
        //     );
        //   },
        // );
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
                    ? () {
                        Get.put(
                          WriteReviewController(productId: productId),
                          tag: productId,
                        );

                        Get.dialog(
                          WriteReviewDialog(productId: productId),
                          barrierDismissible: false,
                        );
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
