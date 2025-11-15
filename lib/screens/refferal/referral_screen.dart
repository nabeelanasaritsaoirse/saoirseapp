import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_strings.dart';
import '../../screens/refferal/referral_controller.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReferralController controller = Get.put(ReferralController());
    final TextEditingController searchController = TextEditingController();

    Widget iconBox({String? image, double? padding}) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 7.h),
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding!.w),
          child: Image.asset(image!),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: appText(
          AppStrings.refferalTitle,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        actions: [
          iconBox(image: AppAssets.notification, padding: 3.w),
          SizedBox(width: 8.w),
          iconBox(image: AppAssets.wallet, padding: 5.w),
          SizedBox(width: 12.w),
          iconBox(image: AppAssets.message, padding: 5.w),
        ],
      ),
      body: Column(
        children: [
          // Header Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            height: 140.h,
            color: AppColors.lightGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appText(
                  AppStrings.referalBannerContent,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                ),
                Image.asset(AppAssets.refferal, width: 120.w, height: 120.h),
              ],
            ),
          ),

          // Content Section
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Referral Code
                    appText(
                      AppStrings.refer_via,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),

                    SizedBox(height: 10.h),
                    Center(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          // loading spinner
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.shadowColor),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 22.h,
                                  width: 22.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.w,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                appText(
                                  AppStrings.fetching_message,
                                  fontSize: 14.sp,
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
                          );
                        }

                        // no code fetched yet or failed
                        if (controller.referralCode.value.isEmpty) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.shadowColor),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                appText(
                                  AppStrings.no_code_fount,
                                  fontSize: 14.sp,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(width: 10.w),
                                InkWell(
                                  onTap: controller.getReferralCode,
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    size: 20.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        //referral code is fetched successfully
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.shadowColor),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              appText(
                                'Code:  ${controller.referralCode.value}',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlack,
                              ),
                              SizedBox(width: 8.w),
                              InkWell(
                                onTap: controller.copyReferralCode,
                                child: Icon(
                                  Icons.copy,
                                  size: 18.sp,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: 20.h),

                    // Share To
                    appText(
                      AppStrings.shareTo,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                    SizedBox(height: 12.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildSocialButton(
                            image: AppAssets.whatsapp,
                            label: AppStrings.whatsapp,
                            color: AppColors.transparent,
                            onTap: controller.shareToWhatsApp,
                            width: 40.h,
                            height: 40.h,
                            radius: 60.r,
                          ),
                          SizedBox(width: 12.w),
                          _buildSocialButton(
                            image: AppAssets.facebook,
                            label: AppStrings.facebook,
                            color: AppColors.transparent,
                            onTap: controller.shareToFacebook,
                            width: 40.h,
                            height: 40.h,
                            radius: 60.r,
                          ),
                          SizedBox(width: 12.w),
                          _buildSocialButton(
                            image: AppAssets.telegram,
                            label: AppStrings.telegram,
                            color: AppColors.transparent,
                            onTap: controller.shareToTelegram,
                            width: 40.h,
                            height: 40.h,
                            radius: 60.r,
                          ),
                          SizedBox(width: 12.w),
                          _buildSocialButton(
                            image: AppAssets.x,
                            label: AppStrings.twitter,
                            color: AppColors.transparent,
                            onTap: controller.shareToTwitter,
                            width: 40.h,
                            height: 40.h,
                            radius: 60.r,
                          ),
                          SizedBox(width: 12.w),
                          _buildSocialButton(
                            image: AppAssets.gmail,
                            label: AppStrings.gmail,
                            color: AppColors.transparent,
                            onTap: controller.shareToGmail,
                            width: 40.h,
                            height: 40.h,
                            radius: 60.r,
                          ),
                          SizedBox(width: 12.w),
                          InkWell(
                            onTap: () => controller.shareMore(),
                            child: Column(
                              children: [
                                Container(
                                  width: 40.h,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.more_horiz),
                                ),
                                SizedBox(height: 6.h),
                                appText(
                                  AppStrings.more,
                                  fontSize: 12.sp,
                                  color: AppColors.darkGray,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // Your Referral Section
                    appText(
                      AppStrings.your_refferal,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                    SizedBox(height: 12.h),

                    // Search Bar using AppTextField
                    appTextField(
                      controller: searchController,
                      hintText: AppStrings.search,
                      fillColor: AppColors.white,
                      textColor: AppColors.textBlack,
                      hintColor: AppColors.grey,
                      borderRadius: BorderRadius.circular(22.r),
                      borderSide: BorderSide(
                        color: AppColors.shadowColor,
                        width: 1.w,
                      ),
                      prefixWidget: Icon(Icons.search, color: AppColors.grey),
                      onChanged: controller.filterReferrals,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 8.h,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Table Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 8.r,
                            spreadRadius: 1.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: appText(
                              AppStrings.no,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGray,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: appText(
                              AppStrings.name,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGray,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: appText(
                              AppStrings.purchase_item,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGray,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: appText(
                              AppStrings.commission,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGray,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Obx(() {
                      if (controller.isDashboardLoading.value) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (controller.filteredReferrals.isEmpty) {
                        return Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppAssets.no_data,
                                    width: 140.w,
                                    height: 140.h,
                                  ),
                                  appText(
                                    AppStrings.noRefferal,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textBlack,
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  appText(
                                    AppStrings.no_refferal_content,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlack,
                                  ),
                                ],
                              ),
                            ));
                      }

                      return Column(
                        children: controller.filteredReferrals
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key + 1;
                          final user = entry.value;

                          final plan = user.installmentPlan;
                          final commissionEarned = plan?.commissionEarned ?? 0;
                          final daysPaid = plan?.daysPaid ?? 0;
                          final totalDays = plan?.days ?? 0;
                          // final planName = plan?.planName ?? '-';
                          final hasPurchased = user.hasPurchased ? 'Yes' : 'No';

                          return Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.symmetric(
                              vertical: 14.h,
                              horizontal: 16.w,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowColor,
                                  blurRadius: 8.r,
                                  spreadRadius: 1.r,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // No.
                                Expanded(
                                  flex: 1,
                                  child: appText(
                                    index.toString(),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlack,
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                // Name
                                Expanded(
                                  flex: 3,
                                  child: appText(
                                    user.name,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlack,
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                // Purchase Progress (2/17)
                                Expanded(
                                  flex: 3,
                                  child: appText(
                                    user.progress.isNotEmpty
                                        ? user.progress
                                        : "$daysPaid/$totalDays",
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: hasPurchased == 'Yes'
                                        ? AppColors.green
                                        : AppColors.mediumGray,
                                  ),
                                ),

                                // 🔹 Commission
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "₹${commissionEarned.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textBlack,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required String image,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required double height,
    required double width,
    required double radius,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
