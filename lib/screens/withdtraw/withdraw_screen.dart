import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/custom_appbar.dart';
import '../booking_confirmation/booking_confirmation_screen.dart';
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
  final _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appText("Enter the account details",
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  fontSize: 16.sp),
              SizedBox(height: 15.h),

              // NAME
              appText("Account holder name",
                  color: AppColors.grey, fontSize: 15.sp),
              SizedBox(
                height: 6.h,
              ),
              appTextField(
                controller: withdrawController.nameController,
                hintText: "Name",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                textInputType: TextInputType.name,
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15.h),

              // ACCOUNT NUMBER
              appText("Account number", color: AppColors.grey, fontSize: 15.sp),
              SizedBox(
                height: 6.h,
              ),
              appTextField(
                controller: withdrawController.accController,
                hintText: "Account number",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                textInputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Account number is required";
                  } else if (value.length < 6) {
                    return "Enter valid account number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15.h),

              // CONFIRM ACCOUNT NUMBER
              appText("Confirm account number",
                  color: AppColors.grey, fontSize: 15.sp),
              SizedBox(
                height: 6.h,
              ),
              appTextField(
                controller: withdrawController.confirmAccController,
                hintText: "Account number",
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                textInputType: TextInputType.number,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please confirm account number";
                  } else if (value != withdrawController.accController.text) {
                    return "Account numbers do not match";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15.h),

              // IFSC
              appText("IFSC code", color: AppColors.grey, fontSize: 15.sp),
              SizedBox(
                height: 6.h,
              ),
              appTextField(
                controller: withdrawController.ifscController,
                hintText: "IFSC code",
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                textInputType: TextInputType.text,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "IFSC code is required";
                  } else if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$')
                      .hasMatch(value.toUpperCase())) {
                    return "Enter valid IFSC code";
                  }
                  return null;
                },
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

              // TRANSFER BUTTON
              appButton(
                child: appText(
                  "Transfer",
                  color: AppColors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    appToast(title: "Success", content: "Validation passed!");
                    Get.to(BookingConfirmationScreen());
                  }
                },
                buttonColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
