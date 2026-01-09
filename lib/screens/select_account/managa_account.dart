import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../models/bank_account_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import 'add_account.dart';
import 'select_account_controller.dart';

class ManageAccountScreen extends StatelessWidget {
  ManageAccountScreen({super.key});

  final SelectAccountController controller =
      Get.find<SelectAccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppBar(
        title: "Manage Accounts",
        showBack: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),

            /// ADD ACCOUNT
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

            /// ACCOUNT LIST
            Expanded(
              child: Obx(() {
                if (controller.accountList.isEmpty) {
                  return Center(child: appText("No bank accounts found"));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  itemCount: controller.accountList.length,
                  itemBuilder: (_, index) {
                    final item = controller.accountList[index];
                    return _manageCard(item, index);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _manageCard(BankAccountModel item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          _bankIcon(),
          SizedBox(width: 10.w),
          Expanded(child: _accountText(item)),
          _editDelete(index),
        ],
      ),
    );
  }

  Widget _editDelete(int index) {
    return Column(
      children: [
        _actionIconButton(
          icon: Icons.edit,
          iconColor: AppColors.primaryColor,
          backgroundColor: const Color(0xFFEFF1FF),
          onTap: () => controller.startEdit(index),
        ),
        SizedBox(height: 10.h),
        _actionIconButton(
          icon: Icons.delete,
          iconColor: AppColors.red,
          backgroundColor: const Color(0xFFFFECEC),
          onTap: () {
            DeleteAccountDialog.show(
              onDelete: () => controller.deleteAccount(index),
            );
          },
        ),
      ],
    );
  }

  Widget _actionIconButton({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35.w,
        height: 35.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _bankIcon() => Container(
        height: 45.h,
        width: 45.w,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.account_balance, color: Colors.white, size: 26.sp),
      );

  Widget _accountText(BankAccountModel item) => Column(
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
              textAlign: TextAlign.left),
        ],
      );
}

class DeleteAccountDialog {
  static void show({
    required VoidCallback onDelete,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///  DELETE ICON
              Container(
                width: 56.w,
                height: 56.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE6E6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: AppColors.red,
                    size: 26.sp,
                  ),
                ),
              ),

              SizedBox(height: 14.h),

              /// TITLE
              appText(
                "Delete Account",
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              /// DESCRIPTION
              appText(
                "Are you sure you want to delete this account?",
                fontSize: 13.sp,
                color: AppColors.black54,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20.h),

              /// ACTION BUTTONS
              Row(
                children: [
                  /// CANCEL
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 42.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: appText(
                          "Cancel",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  /// DELETE
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        onDelete();
                      },
                      child: Container(
                        height: 42.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: appText(
                          "Delete",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
