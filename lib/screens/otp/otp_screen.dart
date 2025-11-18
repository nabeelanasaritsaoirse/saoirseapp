// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import 'package:saoirse_app/screens/otp/otp_screen_controller.dart';
import 'package:saoirse_app/widgets/app_button.dart';
import 'package:saoirse_app/widgets/app_text.dart';

import '../../widgets/app_loader.dart';

class VerifyOTPScreen extends StatelessWidget {
  final String phoneNumber;
  final String referral;
  final String username;
  VerifyOTPScreen(
      {super.key,
      required this.phoneNumber,
      required this.referral,
      required this.username});

  late final VerifyOtpController controller = Get.put(
    VerifyOtpController(
      phoneNumber: phoneNumber,
      referral: referral,
      username: username,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(children: [
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),

                /// Title
                appText(
                  "Verify Code",
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                  fontSize: 25.sp,
                  fontFamily: "Poppins",
                ),

                SizedBox(height: 10.h),

                /// Subtitle
                Text.rich(
                  TextSpan(
                    text: "Please enter the code we just sent to the number ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.black,
                      fontFamily: "Poppins",
                    ),
                    children: [
                      TextSpan(
                        text: phoneNumber,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40.h),

                /// OTP Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45.w,
                      height: 55.w,
                      child: TextField(
                        controller: controller.otpControllers[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),

                SizedBox(height: 20.h),

                GestureDetector(
                  onTap: () {},
                  child: appText(
                    "Resend code",
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                    fontFamily: "Poppins",
                  ),
                ),

                SizedBox(height: 40.h),

                /// Verify Button
                Center(
                  child: Obx(() {
                    return controller.isLoading.value
                        ? SizedBox(
                            height: 45.h,
                            width: 160.w,
                            child: Center(child: appLoader()),
                          )
                        : appButton(
                            onTap: controller.verifyOtp,
                            buttonColor: AppColors.primaryColor,
                            buttonText: AppStrings.verify,
                            textColor: AppColors.white,
                            height: 45.h,
                            width: 160.w,
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: controller.isLoading.value,
          child: appLoader(),
        ),
      ]),
    );
  }
}
