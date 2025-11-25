import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/pending_transaction/pending_transaction_controller.dart';

import '../../constants/app_strings.dart';
import '../../widgets/custom_appbar.dart';
import '../transaction_succsess/transactionSuccsess.dart';
import '/constants/app_colors.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';

class Pendingtrancation extends StatelessWidget {
  const Pendingtrancation({super.key});

  @override
  Widget build(BuildContext context) {
    final PendingTransactionController controller = Get.put(PendingTransactionController());

    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: CustomAppBar(
        title: AppStrings.pending_transaction,
        showBack: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 8.h),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: controller.transactions.length,
                itemBuilder: (context, index) {
                  final item = controller.transactions[index];
                  final RxBool isSelected = item['isSelected'];

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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                item["image"],
                                width: 80.w,
                                height: 70.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    appText(item["title"],
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack,
                                        fontFamily: "poppins",
                                        textAlign: TextAlign.start),
                                    SizedBox(height: 2.h),
                                    appText(
                                      item["subtitle"],
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textBlack,
                                      fontFamily: "poppins",
                                    ),
                                    SizedBox(height: 6.h),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(6.r),
                                          ),
                                          child: appText("Pay Now",
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.white,
                                              fontFamily: "poppins",
                                              fontStyle: FontStyle.italic),
                                        ),
                                        SizedBox(width: 10.w),
                                        appText(
                                          "₹${item['price']}",
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                          fontFamily: "poppins",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: Icon(
                                isSelected.value ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                color: isSelected.value ? AppColors.primaryColor : AppColors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Obx(
            () => Container(
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
                        fontFamily: "poppins",
                      ),
                      appText(
                        "₹${controller.totalAmount}",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        fontFamily: "poppins",
                      ),
                    ],
                  ),
                  appButton(
                    onTap: () {
                      Get.to(Transactionsuccsess());
                    },
                    child: Center(
                      child: appText("Pay Now",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          fontFamily: "poppins",
                          fontStyle: FontStyle.italic),
                    ),
                    // borderWidth: 1.w,
                    width: 120.w,
                    height: 40.h,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    // borderColor: AppColors.primaryColor,
                    buttonColor: AppColors.mediumAmber,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
