import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import 'package:saoirse_app/screens/order_history/order_history_controller.dart';
import 'package:saoirse_app/widgets/app_text.dart';
import 'package:saoirse_app/widgets/custom_appbar.dart';
import 'package:saoirse_app/widgets/order_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({super.key});

  final OrderHistoryController controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      //--------------------- APP BAR -----------------------
      appBar: 
      CustomAppBar(
        title: AppStrings.order_history_label,
        showBack: true,
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
