// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../screens/refferal/referral_controller.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/app_text.dart';

class ReferralQrPopup extends StatelessWidget {
  ReferralQrPopup({super.key});

  final ReferralController controller = Get.find<ReferralController>();

  final GlobalKey _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 4.h),

                  // Heading
                  appText(
                    "Invite & Earn",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),
                  appText(
                    "Share your code or QR with friends and start earning rewards.",
                    fontSize: 12.sp,
                    color: AppColors.grey,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 16.h),

                  // Code box
                  Obx(() {
                    final code = controller.referralCode.value;

                    if (code.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: CupertinoActivityIndicator(),
                      );
                    }
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
                            "Code:  $code",
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

                  SizedBox(height: 16.h),

                  // QR Code
                  Obx(() {
                    final link = controller.referralLink;

                    if (controller.referralCode.value.isEmpty) {
                      return const SizedBox();
                    }
                    return Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: RepaintBoundary(
                        key: _qrKey,
                        child: QrImageView(
                          data: link,
                          size: 200.w,
                          version: QrVersions.auto,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: 16.h),

                  // Share section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: appText(
                      AppStrings.shareTo,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Obx(() {
                    final link = controller.referralLink;

                    if (controller.referralCode.value.isEmpty) {
                      return const SizedBox();
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildSocialButton(
                            image: AppAssets.whatsapp,
                            label: AppStrings.whatsapp,
                            onTap: () => controller.shareQrImage(
                              qrKey: _qrKey,
                              message:
                                  "Join this app! Use my referral link: $link",
                            ),
                          ),
                          SizedBox(width: 12.w),
                          _buildSocialButton(
                            image: AppAssets.facebook,
                            label: AppStrings.facebook,
                            onTap: () => controller.shareQrImage(
                              qrKey: _qrKey,
                              message:
                                  "Join this app! Use my referral link: $link",
                            ),
                          ),
                          SizedBox(width: 12.w),
                          _buildSocialButton(
                            image: AppAssets.telegram,
                            label: AppStrings.telegram,
                            onTap: () => controller.shareQrImage(
                              qrKey: _qrKey,
                              message:
                                  "Join this app! Use my referral link: $link",
                            ),
                          ),
                          SizedBox(width: 12.w),
                          _buildSocialButton(
                            image: AppAssets.x,
                            label: AppStrings.twitter,
                            onTap: () => controller.shareQrImage(
                              qrKey: _qrKey,
                              message:
                                  "Join this app! Use my referral link: $link",
                            ),
                          ),
                          SizedBox(width: 12.w),
                          _buildSocialButton(
                            image: AppAssets.gmail,
                            label: AppStrings.gmail,
                            onTap: () => controller.shareQrImage(
                              qrKey: _qrKey,
                              message:
                                  "Join this app! Use my referral link: $link",
                            ),
                          ),
                          SizedBox(width: 12.w),
                          InkWell(
                            onTap: () => controller.shareQrImage(
                              qrKey: _qrKey,
                              message:
                                  "Join this app! Use my referral link: $link",
                            ),
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
                    );
                  }),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          // Close button (side/top-right)
          Positioned(
            right: 10.w,
            top: 10.h,
            child: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 18.sp,
                  color: AppColors.darkGray,
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          appText(
            label,
            fontSize: 11.sp,
            color: AppColors.darkGray,
          ),
        ],
      ),
    );
  }
}

// Helper function to show the popup
Future<void> showReferralQrPopup(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => ReferralQrPopup(),
  );
}
