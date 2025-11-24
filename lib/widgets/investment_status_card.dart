import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/constants/app_gradient.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import 'package:saoirse_app/widgets/app_text.dart';

class InvestmentStatusCard extends StatelessWidget {
  final double progress;
  final int balanceAmount;
  final int daysLeft;
  final VoidCallback onPayNow;

  const InvestmentStatusCard({
    super.key,
    required this.progress,
    required this.balanceAmount,
    required this.daysLeft,
    required this.onPayNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: AppGradients.progressIndicatoryGradient,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appText(
            AppStrings.investment_label,
            fontSize: 15.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),

          SizedBox(height: 12.h),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              height: 14.h,
              width: double.infinity,
              color: AppColors.whiteGradient,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        height: 14.h,
                        width: constraints.maxWidth * progress,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: AppGradients.progressbarGradient),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 18.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appText(AppStrings.balance,
                      fontSize: 12.sp,
                      color: AppColors.white70,
                      fontWeight: FontWeight.w500),
                  SizedBox(height: 4.h),
                  appText(
                    "₹$balanceAmount",
                    fontSize: 17.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),

              // Days Left
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  appText(AppStrings.days_left,
                      fontSize: 12.sp,
                      color: AppColors.white70,
                      fontWeight: FontWeight.w500),
                  SizedBox(height: 4.h),
                  Text(
                    "$daysLeft",
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Pay Now Button
              GestureDetector(
                onTap: onPayNow,
                child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppGradients.paynowGradient,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: appText(
                      AppStrings.pay_now,
                      color: AppColors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
