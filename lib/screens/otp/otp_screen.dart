import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import 'package:saoirse_app/screens/otp/otp_screen_controller.dart';
import 'package:saoirse_app/widgets/app_button.dart';
import 'package:saoirse_app/widgets/app_text.dart';

class VerifyOTPScreen extends StatelessWidget {
  final String phoneNumber;

  VerifyOTPScreen({super.key, required this.phoneNumber});

  final VerifyOtpController controller = Get.put(VerifyOtpController());

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
      body: Padding(
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
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 65.w,
                  height: 65.w,
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
                      if (value.isNotEmpty && index < 3) {
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
              child: appButton(
                onTap: controller.verifyOtp,
                buttonColor: AppColors.primaryColor,
                buttonText: AppStrings.verify,
                textColor: AppColors.white,
                height: 45.h,
                width: 160.w,
              ),
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
