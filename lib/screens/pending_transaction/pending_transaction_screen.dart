import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_appbar.dart';
import '../my_wallet/my_wallet_controller.dart';
import '/constants/app_colors.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';
import 'pending_transaction_controller.dart';

class PendingTransaction extends StatelessWidget {
  const PendingTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final PendingTransactionController controller =
        Get.put(PendingTransactionController());

    Get.put(MyWalletController(), permanent: true);

    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: CustomAppBar(
        title: AppStrings.pending_transaction,
        showBack: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 8.h),

          //-------------------------------- LIST SECTION -------------------------------
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: appLoader());
              }

              if (controller.transactions.isEmpty) {
                return Center(
                  child: Text(
                    "No pending payment",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: controller.transactions.length,
                itemBuilder: (context, index) {
                  final item = controller.transactions[index];
                  final RxBool isSelected = controller.selectedList[index];

                  return GestureDetector(
                    onTap: () {
                      controller.toggleSelection(index);
                    },
                    child: Obx(
                      () => Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 20.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 6.w),

                            //-------------------------------- IMAGE (Placeholder) -------------------------------
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.asset(
                                AppAssets.mobile,
                                width: 80.w,
                                height: 70.h,
                                fit: BoxFit.contain,
                              ),
                            ),

                            //-------------------------------- TEXT CONTENT -------------------------------
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    appText(
                                      item.productName,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textBlack,
                                    ),
                                    SizedBox(height: 2.h),
                                    appText(
                                      "Installment ${item.installmentNumber}",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textBlack,
                                    ),
                                    SizedBox(height: 6.h),
                                    appText(
                                      "₹${item.amount}",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //-------------------------------- RADIO BUTTON -------------------------------
                            Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: Icon(
                                isSelected.value
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: isSelected.value
                                    ? AppColors.primaryColor
                                    : AppColors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

//-------------------------------- BOTTOM TOTAL AMOUNT SECTION -------------------------------
          Obx(() {
            if (controller.transactions.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 8.r,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appText(
                        "Total Amount",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey,
                      ),
                      appText(
                        "₹${controller.totalAmount}",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ],
                  ),

                  // Pay now button
                  appButton(
                    onTap: () {
                      controller.showPaymentMethodSheet();
                    },
                    child: Center(
                      child: appText(
                        "Pay Now",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    width: 120.w,
                    height: 40.h,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    buttonColor: AppColors.mediumAmber,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
