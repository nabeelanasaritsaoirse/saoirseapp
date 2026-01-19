// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_appbar.dart';
import 'select_account_controller.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final SelectAccountController controller =
        Get.find<SelectAccountController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: "Add Account",
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appText(
                "Enter the account details",
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontSize: 16.sp,
              ),
              SizedBox(height: 15.h),

              /// ACCOUNT HOLDER NAME
              appText("Account holder name",
                  color: AppColors.grey, fontSize: 15.sp),
              SizedBox(height: 6.h),
              appTextField(
                controller: controller.nameController,
                hintText: "Name",
                textInputType: TextInputType.name,
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),

              SizedBox(height: 15.h),

              /// ACCOUNT NUMBER
              appText("Account number", color: AppColors.grey, fontSize: 15.sp),
              SizedBox(height: 6.h),
              appTextField(
                controller: controller.accController,
                hintText: "Account number",
                textInputType: TextInputType.number,
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Account number is required";
                  }

                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "Account number must contain only digits";
                  }
                  if (value.length < 9 || value.length > 18) {
                    return "Account number must be between 9 and 18 digits";
                  }

                  return null;
                },
              ),

              SizedBox(height: 15.h),

              /// CONFIRM ACCOUNT NUMBER
              appText("Confirm account number",
                  color: AppColors.grey, fontSize: 15.sp),
              SizedBox(height: 6.h),
              appTextField(
                controller: controller.confirmAccController,
                hintText: "Confirm account number",
                textInputType: TextInputType.number,
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please confirm account number";
                  }

                  if (value != controller.accController.text.trim()) {
                    return "Account numbers do not match";
                  }

                  return null;
                },
              ),

              SizedBox(height: 15.h),

              /// IFSC CODE
              appText("IFSC code", color: AppColors.grey, fontSize: 15.sp),
              SizedBox(height: 6.h),
              appTextField(
                controller: controller.ifscController,
                hintText: "IFSC code",
                textInputType: TextInputType.text,
                hintColor: AppColors.grey,
                textColor: AppColors.black,
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

              /// BANK NAME
              ///
              SizedBox(height: 15.h),
              appText("Bank name", color: AppColors.grey, fontSize: 15.sp),
              SizedBox(height: 6.h),
              appTextField(
                controller: controller.bankNameController,
                hintText: "Bank name",
                textInputType: TextInputType.text,
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Bank name is required";
                  }
                  if (value.trim().length < 3) {
                    return "Enter valid bank name";
                  }
                  return null;
                },
              ),

              SizedBox(height: 15.h),

              /// BRANCH NAME
              appText("Branch name", color: AppColors.grey, fontSize: 15.sp),
              SizedBox(height: 6.h),
              appTextField(
                controller: controller.branchNameController,
                hintText: "Branch name",
                textInputType: TextInputType.text,
                hintColor: AppColors.grey,
                textColor: AppColors.black,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Branch name is required";
                  }
                  if (value.trim().length < 3) {
                    return "Enter valid branch name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.h),

              /// SAVE BUTTON
              appButton(
                buttonColor: AppColors.primaryColor,
                child: appText(
                  "Save",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    controller.saveAccount();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
