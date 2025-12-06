// FULL UPDATED REFERRAL SCREEN
// Behaves exactly as requested
// No design or UI property changes

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:saoirse_app/widgets/app_button.dart';

import '../../constants/app_strings.dart';
import '../../models/refferal_info_model.dart';
import '../../screens/refferal/referral_controller.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_appbar.dart';
import '../invite_friend/invite_friend_details_screen.dart';
import '../login/login_controller.dart';
import '../my_wallet/my_wallet.dart';
import '../notification/notification_controller.dart';
import '../notification/notification_screen.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  late ReferralController controller;
  late LoginController loginController;
  late TextEditingController searchController;
  late FocusNode searchFocusNode;
  late ScrollController scrollController;

  final double bannerHeight = 140.h;

  @override
  void initState() {
    super.initState();

    controller = Get.put(ReferralController());
    loginController = Get.put(LoginController());
    searchController = TextEditingController();
    scrollController = ScrollController();
    searchFocusNode = FocusNode();

    searchFocusNode.addListener(() {
      if (searchFocusNode.hasFocus) {
        // user tapped search — hide banner
        Future.delayed(Duration(milliseconds: 80), () {
          scrollController.animateTo(
            bannerHeight,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      } else {
        // search unfocused — show banner again
        Future.delayed(Duration(milliseconds: 80), () {
          scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: AppStrings.refferalTitle,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconBox(
                image: AppAssets.notification,
                padding: 3.w,
                onTap: () {
                  Get.to(() => NotificationScreen());
                },
              ),

              /// BADGE ONLY IF unreadCount > 0
              Obx(() {
                final count =
                    Get.find<NotificationController>().unreadCount.value;
                if (count == 0) return const SizedBox();

                return Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count > 9 ? "9+" : count.toString(),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          SizedBox(width: 8.w),
          IconBox(
              image: AppAssets.wallet,
              padding: 5.w,
              onTap: () {
                Get.to(WalletScreen());
              }),
          SizedBox(width: 12.w),
        ],
      ),
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                height: bannerHeight,
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
                    Image.asset(
                      AppAssets.refferal,
                      width: 120.w,
                      height: 120.h,
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: _buildContentSection(
              loginController: loginController,
              referralController: controller,
              searchController: searchController,
              focusNode: searchFocusNode,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection({
    required ReferralController referralController,
    required LoginController loginController,
    required TextEditingController searchController,
    required FocusNode focusNode,
  }) {
    // ✅ NOTHING BELOW THIS POINT HAS BEEN CHANGED
    // ✅ EXACT SAME UI, SPACING, COLORS, TEXT, LIST, EVERYTHING

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appText(
              AppStrings.refer_via,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
            Obx(() {
              if (referralController.referrer.value != null) {
                log("🟢 Showing ReferredByCard");
                return referredByCard(referralController.referrer.value!);
              } else {
                log("🔵 Showing Apply Referral Button");
                return applyReferralSection(); // show input + apply button
              }
            })
          ],
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

        SizedBox(height: 20.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appText(
              AppStrings.your_refferal,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
            Obx(() {
              final count = controller.filteredReferrals.length;
              return Align(
                alignment: AlignmentGeometry.centerRight,
                child: appText(
                  "$count / 50",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGray,
                ),
              );
            }),
          ],
        ),

        SizedBox(height: 12.h),

        // ✅ Search bar WITH SAME DESIGN but now has focusNode
        appTextField(
          controller: searchController,
          focusNode: focusNode,
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

        // Referral list / empty state / loading
        Obx(() {
          if (controller.isDashboardLoading.value) {
            return SizedBox(
              height: 40.h,
              width: 150.w,
              child: Center(
                child: appLoader(),
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

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.filteredReferrals.length,
            itemBuilder: (context, index) {
              final referral = controller.filteredReferrals[index];

              return InkWell(
                onTap: () => Get.to(InviteFriendDetailsScreen(
                  userId: referral.referredUser!.id,
                )),
                child: Container(
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
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // No.
                      Expanded(
                        flex: 1,
                        child: appText(
                          (index + 1).toString(),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // NAME (Null safe)
                      Expanded(
                        flex: 3,
                        child: appText(
                          referral.referredUser?.name ?? "N/A",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,
                          textAlign: TextAlign.start,
                        ),
                      ),

                      // TOTAL PRODUCTS
                      Expanded(
                        flex: 3,
                        child: appText(
                          referral.totalProducts?.toString() ?? "0",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.green,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // TOTAL COMMISSION
                      Expanded(
                        flex: 3,
                        child: Text(
                          "₹${(referral.totalCommission).toStringAsFixed(0)}",
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
                ),
              );
            },
          );
        }),
      ],
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

  void showReferralInputPopup() {
    final TextEditingController referralCtrl = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // ignore: deprecated_member_use
                      color: AppColors.green.withOpacity(0.1),
                    ),
                    child: Icon(Iconsax.tick_circle,
                        size: 25.sp, color: Colors.green),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close))
                ],
              ),
              SizedBox(height: 10.h),

              appText(AppStrings.enter_refferal_code,
                  fontSize: 16.sp, fontWeight: FontWeight.w700),
              SizedBox(height: 8.h),

              appText(AppStrings.refferal_discription,
                  color: AppColors.black54, fontSize: 10.sp),
              SizedBox(height: 15.h),

              // INPUT FIELD
              appTextField(
                contentPadding: EdgeInsets.all(10.r),
                controller: referralCtrl,
                textColor: AppColors.black,
                hintText: "Enter the referral code",
                hintSize: 14.sp,
                hintColor: AppColors.grey,
              ),

              SizedBox(height: 15.h),

              Row(
                children: [
                  // CANCEL BUTTON
                  Expanded(
                    child: appButton(
                      onTap: () => Get.back(),
                      borderColor: Colors.grey,
                      textColor: AppColors.textBlack,
                      buttonText: "Cancel",
                      fontSize: 12.sp,
                      height: 35.h,
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // APPLY BUTTON
                  Expanded(
                    child: appButton(
                      onTap: () async {
                        Get.back(); // close input popup
                        await Future.delayed(Duration(milliseconds: 100));
                        bool success = await Get.put(LoginController())
                            .applyReferral(referralCtrl.text.trim());

                        if (success) {
                          showReferralSuccessPopup();
                        }
                      },
                      buttonColor: AppColors.primaryColor,
                      textColor: AppColors.white,
                      buttonText: "Apply",
                      fontSize: 12.sp,
                      height: 35.h,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget applyReferralSection() {
    if (loginController.referralApplied.value) return SizedBox(); // hide input

    return GestureDetector(
      onTap: () => showReferralInputPopup(),
      child: Text(
        "Apply Referral",
        style: TextStyle(
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
    );
  }

  void showReferralSuccessPopup() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CELEBRATION ICON
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // ignore: deprecated_member_use
                  color: AppColors.green.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.celebration,
                  size: 38.sp,
                  color: AppColors.green,
                ),
              ),

              SizedBox(height: 15.h),

              appText(
                AppStrings.refferal_applied_success,
                textAlign: TextAlign.center,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),

              SizedBox(height: 20.h),

              // THANKS BUTTON (appButton)
              appButton(
                onTap: () {
                  Get.back();
                  controller.fetchReferralData();
                },
                buttonColor: Colors.indigo.shade900,
                height: 48.h,
                width: double.infinity,
                buttonText: "Thanks",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget referredByCard(ReferrerInfoModel r) {
  return GestureDetector(
    onTap: () {
      print("👆 ReferredBy Clicked → Navigating to Friend Details");
      print("📩 Passing UserId = ${r.userId}");

      Get.to(() => InviteFriendDetailsScreen(
            userId: r.userId, // <-- Passing user ID
          ));
    },
    child: Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.green.withOpacity(.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(r.profilePicture)),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Referred by:",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Text(r.name, style: TextStyle(fontSize: 15)),
              Text("Code: ${r.referralCode}",
                  style: TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    ),
  );
}
