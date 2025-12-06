// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/app_loader.dart';
import '../add_address/add_address.dart';
import '../order_details/order_details_controller.dart';
import '../order_details/order_details_screen.dart';
import 'select_address_controller.dart';
import '../../models/product_details_model.dart';

class SelectAddress extends StatelessWidget {
  final ProductDetailsData? product;
  final String? selectVarientId;
  final int selectedDays; // NEW
  final double selectedAmount;
  final int? quantity;

  SelectAddress({
    super.key,
    this.product,
    this.selectVarientId,
    required this.selectedDays,
    required this.selectedAmount,this.quantity,
  });

  final SelectAddressController controller = Get.put(SelectAddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: AppStrings.select_address,
        showBack: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: appButton(
                buttonColor: AppColors.primaryColor,
                child: appText(
                  "+ Add New Address",
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                onTap: () => Get.to(AddAddress()),
              ),
            ),
            SizedBox(height: 10.h),

            // 📌 Address List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: appLoader());
                }

                if (controller.addressList.isEmpty) {
                  return Center(
                    child: appText("No address found"),
                  );
                }

                return ListView.builder(
                  itemCount: controller.addressList.length,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  itemBuilder: (context, index) {
                    final item = controller.addressList[index];

                    return Obx(
                      () => addressCard(
                        title: "${item.addressType} (${item.name})",
                        subtitle:
                            "${item.addressLine1}, ${item.city}, ${item.state}, ${item.pincode}",
                        isSelected: controller.selectedIndex.value == index,
                        onTap: () => controller.selectAddress(index),
                      ),
                    );
                  },
                );
              }),
            ),

            // Continue Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              child: appButton(
                buttonColor: AppColors.primaryColor,
                child: appText(
                  "Continue",
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                onTap: () {
  final selectedAddress =
      controller.addressList[controller.selectedIndex.value];

  if (!Get.isRegistered<OrderDetailsController>()) {
    Get.put(OrderDetailsController());
  }

  final orderCtrl = Get.find<OrderDetailsController>();

  // Save selected data
  orderCtrl.selectedDays.value = selectedDays;
  orderCtrl.selectedAmount.value = selectedAmount;

  // Navigate to Order Details
  Get.to(() => OrderDetailsScreen(
        addresses: selectedAddress,
        product: product,
        selectedDays: selectedDays,
        selectVarientId: selectVarientId ?? "",
        selectedAmount: selectedAmount,
        quantity: quantity,
      ));
},

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addressCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(26), // smoother like image
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4), // softer long shadow
            ),
          ],
        ),
        child: Row(
          children: [
            // LEFT ICON CIRCLE
            Container(
              height: 45.h,
              width: 45.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor, // navy blue
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: AppColors.white,
                size: 26.sp,
              ),
            ),

            SizedBox(width: 10.w),

            // TEXT SECTION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appText(
                    title,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 4.h),
                  appText(
                    subtitle,
                    fontSize: 13.sp,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    color: Colors.black.withOpacity(0.55),
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),

            // CUSTOM RADIO BUTTON (MATCHES IMAGE)
            Container(
              height: 22.h,
              width: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryColor,
                  width: 2.2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 12.h,
                        width: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
