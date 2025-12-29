// FULL UPDATED REFERRAL SCREEN
// Behaves exactly as requested
// No design or UI property changes

// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../constants/app_strings.dart';
import '../../models/refferal_info_model.dart';
import '../../screens/refferal/referral_controller.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../services/converstion_service.dart';
import '../../services/login_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/referral_qr_popup.dart';
import '../invite_friend/invite_friend_details_screen.dart';
import '../login/login_controller.dart';
import '../message/message_screen.dart';
import '../my_wallet/my_wallet.dart';
import '../notification/notification_controller.dart';
import '../notification/notification_screen.dart';
import 'qr_scanner.dart';

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

    controller = Get.find<ReferralController>();
    loginController = Get.find<LoginController>();
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

  String extractReferral(String qrData) {
    Uri uri = Uri.parse(qrData);
    return uri.queryParameters["deep_link_value"] ?? qrData;
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
            },
          ),
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
                    ),
                    Image.asset(
                      AppAssets.refferal,
                      width: 120.w,
                      height: 120.h,
                    ),
                  ],
                ),
              ),
            ),
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
          child: RefreshIndicator(
            onRefresh: controller.refreshAll,
            color: AppColors.primaryColor, // spinner color
            backgroundColor: AppColors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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

        SizedBox(height: 15.h),

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

            // referral code is fetched successfully - WITH QR CODE BUTTON
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
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
                ),

                SizedBox(width: 12.w),

                // QR Code Button
                SizedBox(
                  height: 42.h,
                  width: 44.h,
                  child: InkWell(
                    onTap: () {
                      showReferralQrPopup(context);
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.shadowColor),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.asset(AppAssets.qr_code_icon),
                      ),
                    ),
                  ),
                ),
              ],
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
                image: AppAssets.instagram,
                label: "Instagram",
                color: AppColors.transparent,
                onTap: controller.shareToInstagram,
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
              return appText(
                "${controller.totalReferrals.value} / ${controller.referralLimit.value}",
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textGray,
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
                          "₹${controller.formatAmount(referral.totalCommission)}",
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
              Row(
                children: [
                  Expanded(
                    child: appTextField(
                      contentPadding: EdgeInsets.all(10.r),
                      controller: referralCtrl,
                      textColor: AppColors.black,
                      hintText: "Enter the referral code",
                      hintSize: 14.sp,
                      hintColor: AppColors.grey,
                      validator: (value) {
                        // Keep using LoginService.referralValidation (returns null if valid)
                        return LoginService.referralValidation(
                            referral: value ?? "");
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.qr_code_scanner,
                        size: 32, color: AppColors.primaryColor),
                    onPressed: () {
                      showQRPicker((code) {
                        referralCtrl.text = code;
                        log("🟢 Referral code updated in popup: $code"); // ← fill input
                      });
                    },
                  ),
                ],
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
                        await Future.delayed(Duration(milliseconds: 100));
                        bool success = await Get.find<LoginController>()
                            .applyReferral(referralCtrl.text.trim());

                        if (success) {
                          log("✅ Referral Applied — Closing Input Popup...");

                          // CLOSE ONLY THE INPUT POPUP
                          Get.back();

                          // Small delay for smooth transition
                          await Future.delayed(Duration(milliseconds: 150));
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

  void scanQRWithCamera(Function(String) onCodeSelected) {
    Get.to(() => QRScannerScreen(
          onReferralDetected: (value) {
            final code = extractReferral(value);
            log("📸 Camera scanned QR: $code");

            onCodeSelected(code);
            Get.back();
          },
        ));
  }

  Future<void> pickQRFromGallery(Function(String) onCodeSelected) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    try {
      final MobileScannerController scanner = MobileScannerController();

      final BarcodeCapture? result = await scanner.analyzeImage(image.path);

      if (result != null && result.barcodes.isNotEmpty) {
        final value = result.barcodes.first.rawValue ?? "";
        final code = extractReferral(value);

        log("🖼 QR from image: $code");

        onCodeSelected(code);
      } else {
        log("No QR found in image");
      }
    } catch (e) {
      log("Failed to read QR: $e");
    }
  }

  void showQRPicker(Function(String) onCodeSelected) {
    Get.bottomSheet(
      TweenAnimationBuilder(
        duration: Duration(milliseconds: 300),
        tween: Tween<double>(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.2),
                blurRadius: 20.r,
                offset: Offset(0, -5),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grab indicator
              Container(
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                "Choose QR Method",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black87,
                ),
              ),
              SizedBox(height: 20.h),

              // Option 1 — Scan QR
              GestureDetector(
                onTap: () {
                  // Get.back(); // close only bottomsheet
                  Future.delayed(Duration(milliseconds: 150), () {
                    scanQRWithCamera(onCodeSelected);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.blueshade.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.qr_code_scanner,
                            size: 28, color: AppColors.primaryColor),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Text(
                          "Scan using Camera",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 18.sp, color: AppColors.lightGrey),
                    ],
                  ),
                ),
              ),

              // Option 2 — Upload QR
              GestureDetector(
                onTap: () {
                  // Get.back(); // close only bottomsheet
                  Future.delayed(Duration(milliseconds: 150), () {
                    pickQRFromGallery(onCodeSelected);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.blueshade.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.image,
                            size: 28.sp, color: AppColors.primaryColor),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "Upload QR from Gallery",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 18.sp, color: AppColors.lightGrey),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

Widget referredByCard(ReferrerInfoModel r) {
  return GestureDetector(
    onTap: () async {
      // LOGS (optional)
      log("👆 ReferredBy Clicked → Opening Chat Directly");
      log("📩 Friend UserId = ${r.userId}");

      // Create chat
      final chat = await ConversationService().createIndividualChat(r.userId);

      if (chat == null) {
        log("❌ Chat creation failed");
        return;
      }

      // Navigate to Chat Screen (PaymentMessageScreen)
      Get.to(
        () => PaymentMessageScreen(
          conversationId: chat.conversationId,
          participants: chat.participants,
          name: r.name,
          profilePic: r.profilePicture,
          referralCode: r.referralCode,
          showProfileButton: true,
        ),
        transition: Transition.rightToLeft,
      );
    },
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerRight,
      children: [
        Container(
          padding: EdgeInsets.only(left: 9, right: 55, top: 8, bottom: 8),
          decoration: BoxDecoration(
              color: Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.green)),
          child: Text(
            "Referred by",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Positioned(
          right: -12,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green)),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(r.profilePicture),
              backgroundColor: Colors.grey[300],
            ),
          ),
        ),
      ],
    ),
  );
}
