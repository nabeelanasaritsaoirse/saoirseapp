// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/select_account/add_account.dart';

import '../../constants/app_colors.dart';
import '../../models/bank_account_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/app_loader.dart';

import '../withdtraw/withdraw_screen.dart';
import 'select_account_controller.dart';

class SelectAccountScreen extends StatelessWidget {
  SelectAccountScreen({super.key});

  final SelectAccountController controller =
      Get.find<SelectAccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: "Select Account",
        showBack: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),

            /// ➕ ADD NEW ACCOUNT
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: appButton(
                buttonColor: AppColors.primaryColor,
                child: appText(
                  "+ Add New Account",
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                onTap: () => Get.to(() => AddAccountScreen()),
              ),
            ),

            SizedBox(height: 10.h),

            /// 📌 ACCOUNT LIST
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: appLoader());
                }

                if (controller.accountList.isEmpty) {
                  return Center(
                    child: appText("No bank accounts found"),
                  );
                }

                return ListView.builder(
                  itemCount: controller.accountList.length,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  itemBuilder: (context, index) {
                    final item = controller.accountList[index];

                    return accountCard(item: item, index: index);
                  },
                );
              }),
            ),

            /// CONTINUE BUTTON
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
                  final selectedAccount =
                      controller.accountList[controller.selectedIndex.value];

                  Get.to(() => WithdrawScreen(
                        account: selectedAccount,
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🏦 ACCOUNT CARD (SAME STYLE AS ADDRESS)
  Widget accountCard({
    required BankAccountModel item,
    required int index,
  }) {
    return Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(children: [
          /// BANK ICON
          Container(
            height: 45.h,
            width: 45.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child:
                Icon(Icons.account_balance, color: Colors.white, size: 26.sp),
          ),

          SizedBox(width: 10.w),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appText(item.accountHolderName,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.left),
                SizedBox(height: 4.h),
                appText(
                  "${item.bankName} • ${item.branchName}\nA/C: ${item.accountNumber}\nIFSC: ${item.ifscCode}",
                  fontSize: 13.sp,
                  color: AppColors.black54,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),

          // 🔘 RADIO
          // 🔘 RADIO (FIXED)
          Obx(() => GestureDetector(
                onTap: () => controller.selectAccount(index),
                child: Container(
                  height: 22.h,
                  width: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 2.2,
                    ),
                  ),
                  child: controller.selectedIndex.value == index
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
                      : const SizedBox(),
                ),
              ))
        ]));
  }
}
