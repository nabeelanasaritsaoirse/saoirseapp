import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import '/constants/app_colors.dart';
import '/widgets/app_button.dart';

class Transactionsuccsess extends StatefulWidget {
  const Transactionsuccsess({super.key});

  @override
  State<Transactionsuccsess> createState() => _TransactionsuccsessState();
}

class _TransactionsuccsessState extends State<Transactionsuccsess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 220.h,
                child: Image.asset(
                  'assets/images/payment_Sucsess.1.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                AppStrings.payment_Sucsess,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                AppStrings.payment_Sucsess_note,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black,
                  height: 1.h,
                ),
              ),
              SizedBox(height: 30.h),
              appButton(
                buttonText: AppStrings.confirm,
                textColor: AppColors.white,
                height: 45.h,
                width: 300.w,
                buttonColor: AppColors.primaryColor,
                onTap: () {
//
//     CONFIRM BUTTON FUNCTION
//
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
