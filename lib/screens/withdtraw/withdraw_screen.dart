import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'withdraw_controller.dart';
import '/widgets/app_button.dart';
import '/widgets/app_text.dart';
import '/widgets/app_text_field.dart';

class withdraw_screen extends StatefulWidget {
  const withdraw_screen({super.key});

  @override
  State<withdraw_screen> createState() => _withdraw_screenState();
}

class _withdraw_screenState extends State<withdraw_screen> {
  @override
  Widget build(BuildContext context) {
    final Controller = Get.put(withdraw_controller());
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
            size: 25.sp,
          ),
          onTap: () {},
        ),
        title: appText("Withdraw",
            fontWeight: FontWeight.w600,
            color: AppColors.white,
            fontSize: 20.sp),
        centerTitle: false,
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
                controller: Controller.nameController,
                hintText: "Name",
                hintColor: AppColors.grey,
                textColor: AppColors.black),
            SizedBox(height: 15.h),
            appText("Account number", color: AppColors.grey, fontSize: 15.sp),
            appTextField(
                controller: Controller.accController,
                hintText: "Account number",
                hintColor: AppColors.grey,
                textColor: AppColors.black),
            SizedBox(height: 15.h),
            appText("Confirm account number",
                color: AppColors.grey, fontSize: 15.sp),
            appTextField(
                controller: Controller.confirmAccController,
                hintText: "Account number",
                hintColor: AppColors.grey,
                textColor: AppColors.black),
            SizedBox(height: 15.h),
            appText("IFSC code", color: AppColors.grey, fontSize: 15.sp),
            appTextField(
              controller: Controller.ifscController,
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
