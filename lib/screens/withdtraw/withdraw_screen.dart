import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/custom_appbar.dart';
import 'withdraw_controller.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';
import '/widgets/app_text_field.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  @override
  Widget build(BuildContext context) {
    final withdrawController = Get.put(WithdrawController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: "Withdraw",
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appText("Enter the account details",
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontSize: 16.sp),
            SizedBox(height: 15.h),
            appText("Account holder name",
                color: AppColors.grey, fontSize: 15.sp),
            appTextField(
                controller: withdrawController.nameController,
                hintText: "Name",
                hintColor: AppColors.grey,
                textColor: AppColors.black),
            SizedBox(height: 15.h),
            appText("Account number", color: AppColors.grey, fontSize: 15.sp),
            appTextField(
                controller: withdrawController.accController,
                hintText: "Account number",
                hintColor: AppColors.grey,
                textColor: AppColors.black),
            SizedBox(height: 15.h),
            appText("Confirm account number",
                color: AppColors.grey, fontSize: 15.sp),
            appTextField(
                controller: withdrawController.confirmAccController,
                hintText: "Account number",
                hintColor: AppColors.grey,
                textColor: AppColors.black),
            SizedBox(height: 15.h),
            appText("IFSC code", color: AppColors.grey, fontSize: 15.sp),
            appTextField(
              controller: withdrawController.ifscController,
              hintText: "IFSC code",
              hintColor: AppColors.grey,
              textColor: AppColors.black,
            ),
            SizedBox(height: 30.h),
            Center(
              child: appText("Enter Amount",
                  color: AppColors.black, fontSize: 15.sp),
            ),
            SizedBox(height: 5.h),
            Center(
              child: appText("₹1,252.00",
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp),
            ),
            SizedBox(height: 40.h),
            appButton(
              child: appText(
                "Transfer",
                color: AppColors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              onTap: () {},
              buttonColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
