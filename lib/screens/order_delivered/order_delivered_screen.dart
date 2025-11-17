import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/screens/order_delivered/order_delivered_controller.dart';
import 'package:saoirse_app/widgets/app_text.dart';
import 'package:saoirse_app/widgets/order_card.dart';

class OrderDeliveredScreen extends StatelessWidget {
  OrderDeliveredScreen({super.key});

  final OrderDeliveredController controller = Get.put(OrderDeliveredController());

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
        return ListView.builder(
          padding: EdgeInsets.only(top: 7.h),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return OrderCard(
              order: order,
            );
          },
        );
      }),
    );
  }
}
