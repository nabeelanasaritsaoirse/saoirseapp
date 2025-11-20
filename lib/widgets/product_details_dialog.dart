import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/product_detiails_response.dart';
import 'app_button.dart';
import 'app_text.dart';

void showProductDetailsDialog(
  BuildContext context,
  ProductDetails product,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: AppColors.shadowColor,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: appText(
                product.productName,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 14.h),
            _buildInfoRow(AppStrings.productId, product.productId),
            _buildInfoRow(AppStrings.date_of_purchase,
                product.dateOfPurchase.substring(0, 10)),
            _buildInfoRow(AppStrings.total_price, "₹${product.totalPrice}"),
            _buildInfoRow(AppStrings.daily_sip,
                "₹${product.commissionPerDay}${AppStrings.each}"),
            _buildInfoRow(
                AppStrings.myCommission, "₹${product.totalCommission}"),
            _buildInfoRow(
                AppStrings.myTotalErnings, "₹${product.earnedCommission}",
                valueColor: AppColors.green),
            _buildInfoRow(AppStrings.pending_inv, "${product.pendingDays} Days",
                valueColor:
                    product.pendingDays > 0 ? AppColors.red : AppColors.green),
            SizedBox(height: 24.h),
            Center(
              child: SizedBox(
                width: 170.w,
                height: 35.h,
                child: appButton(
                  padding: EdgeInsets.all(0.w),
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(10.r),
                  buttonColor: AppColors.white,
                  borderColor: AppColors.grey,
                  textColor: AppColors.textBlack,
                  child: Center(
                    child: appText(
                      AppStrings.close,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Helper Row Widget
Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        appText(
          label,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGray,
        ),
        appText(
          value,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: valueColor ?? AppColors.textBlack,
          textAlign: TextAlign.right,
        ),
      ],
    ),
  );
}
