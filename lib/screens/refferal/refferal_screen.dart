import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import 'refferal_controller.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import 'package:iconsax/iconsax.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReferralController controller = Get.put(ReferralController());
    final TextEditingController searchController = TextEditingController();

    Widget _iconBox({String? image, double? padding}) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 7.h),
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding!),
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
          _iconBox(image: AppAssets.notification, padding: 3.w),
          SizedBox(width: 8.w),
          _iconBox(image: AppAssets.wallet, padding: 5.w),
          SizedBox(width: 12.w),
          _iconBox(image: AppAssets.message, padding: 5.w),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Header Banner
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

          // 🔹 Content Section
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
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => appText(
                                'Code:  ${controller.referralCode.value}',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlack,
                              ),
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
                      ),
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
                            label: 'WhatsApp',
                            color: const Color(0xFF25D366),
                            onTap: controller.shareToWhatsApp,
                          ),
                          const SizedBox(width: 12),
                          _buildSocialButton(
                            image: AppAssets.facebook,
                            label: 'Facebook',
                            color: const Color(0xFF1877F2),
                            onTap: controller.shareToFacebook,
                          ),
                          const SizedBox(width: 12),
                          _buildSocialButton(
                            image: AppAssets.telegram,
                            label: 'Telegram',
                            color: const Color(0xFF0088CC),
                            onTap: controller.shareToTelegram,
                          ),
                          const SizedBox(width: 12),
                          _buildSocialButton(
                            image: AppAssets.x,
                            label: 'Twitter',
                            color: Colors.black,
                            onTap: controller.shareToTwitter,
                          ),
                          const SizedBox(width: 12),
                          _buildSocialButton(
                            image: AppAssets.gmail,
                            label: 'Gmail',
                            color: const Color(0xFFEA4335),
                            onTap: controller.shareToGmail,
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.more_horiz),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'More',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // 🔹 Your Referral Section
                    appText(
                      "Your referral",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    SizedBox(height: 12.h),

                    // Search Bar using AppTextField
                    AppTextField(
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
                    // 🔹 Table Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
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

                    // 🔹 Referral List
                    Obx(
                      () => Column(
                        children: controller.filteredUsers.map((user) {
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
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // No.
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    user.no.toString(),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                // Name
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),

                                // Purchase Items
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "${user.purchaseItems} items",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                // Commission
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "₹${user.commission}",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
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
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
