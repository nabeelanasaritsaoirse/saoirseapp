import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/order_card.dart';
import 'order_history_controller.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({super.key});

  final OrderHistoryController controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      //--------------------- APP BAR -----------------------
      appBar: CustomAppBar(
        title: AppStrings.order_history_label,
        showBack: true,
      ),

      //--------------------- BODY -----------------------
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: appLoader());
        }

        if (controller.orders.isEmpty) {
          return Center(
            child: Text(
              "No orders found",
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textBlack,
              ),
            ),
          );
        }

        return ListView.builder(
          controller: controller.scrollController,
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
            return OrderCard(order: order);
          },
        );
      }),
    );
  }
}
