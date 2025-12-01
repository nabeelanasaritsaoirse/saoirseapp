// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/screens/kyc/kycScreen.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/profile_menu_card.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../order_delivered/order_delivered_screen.dart';
import '../order_history/order_history_screen.dart';
import '../pending_transaction/pending_transaction_screen.dart';
import '../terms_and_privacy/privacy_policy.dart';
import '../terms_and_privacy/terms_conditions.dart';
import '../transaction_history/transaction_history.dart';
import '../wishlist/wishlist_screen.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController controller;

  @override
  void initState() {
    controller = Get.put(ProfileController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: CustomAppBar(
        title: AppStrings.profile_title,
        showBack: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------- PROFILE BANNER -----------------------
            Obx(() {
              final user = controller.profile.value?.user;

              if (user == null) {
                return SizedBox(
                  height: 200.h,
                  child: Center(child: appLoader()),
                );
              }

              // // --- priority logic ---
              // String primaryContact = "";
              // if (user.email.isNotEmpty) {
              //   primaryContact = user.email;
              // } else if (user.phoneNumber.isNotEmpty) {
              //   primaryContact = user.phoneNumber;
              // }
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // BACKGROUND CONTAINER
                  Container(
                    width: double.infinity,
                    height: 200.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppAssets.profile_bg),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // PROFILE - DETAILS
                  Positioned(
                    top: 39.h, // moves the circle down
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // PROFILE WITH EDIT BUTTON
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 42,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: user.profilePicture.isNotEmpty
                                  ? NetworkImage(user.profilePicture)
                                  : AssetImage(AppAssets.user_img)
                                      as ImageProvider,
                            ),

                            // SMALL EDIT ICON
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () => Get.to(EditProfileScreen()),
                                child: Container(
                                  width: 25.w,
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryColor,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: AppColors.white,
                                    size: 14.sp,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),

                        SizedBox(height: 12.h),

                        appText(user.name,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                            fontSize: 18.sp),
                        // if (primaryContact.isNotEmpty)
                        //   appText(primaryContact,
                        //       fontWeight: FontWeight.w400,
                        //       color: AppColors.textBlack,
                        //       fontSize: 14.sp)
                      ],
                    ),
                  ),
                ],
              );
            }),

            SizedBox(height: 20.h),

            // -------------------- MY ORDERS TITLE ---------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: appText(
                "My Orders",
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),

            SizedBox(height: 10.h),

            // -------------------- MY ORDERS GRID -----------------------
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.myOrders.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                  ),
                  itemBuilder: (_, index) {
                    // Only Wishlist tile should use Obx
                    if (index == 2) {
                      return Obx(() => ProfileMenuCard(
                            icon: controller.myOrders[index]["icon"]!,
                            title: controller.myOrders[index]["title"]!,
                            count:
                                controller.wishlistCount.value, // 🔥 reactive
                            onTap: () {
                              Get.to(WishlistScreen())?.then((_) {
                                controller.fetchWishlistCount();
                              });
                            },
                          ));
                    }

                    // All other tiles do NOT use Obx
                    return ProfileMenuCard(
                      icon: controller.myOrders[index]["icon"]!,
                      title: controller.myOrders[index]["title"]!,
                      onTap: () {
                        if (index == 0) {
                          Get.to(PendingTransaction());
                        } else if (index == 1) {
                          Get.to(OrderHistoryScreen());
                        } else if (index == 2) {
                          Get.to(WishlistScreen());
                        } else if (index == 3) {
                          Get.to(TransactionHistory());
                        } else if (index == 4) {
                          Get.to(OrderDeliveredScreen());
                        } else {}
                      },
                    );
                  },
                )),

            SizedBox(height: 20.h),

            // -------------------- SETTINGS TITLE ---------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: appText(
                "Settings",
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),

            SizedBox(height: 10.h),

            // -------------------- SETTINGS GRID -----------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.settings.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 15.w,
                  mainAxisSpacing: 15.h,
                ),
                itemBuilder: (_, index) {
                  final item = controller.settings[index];
                  final title = item["title"]!;
                  final icon = item["icon"]!;

                  return ProfileMenuCard(
                    icon: icon,
                    title: title,
                    onTap: () {
                      switch (title) {
                        case "KYC":
                          Get.to(() => kycScreen(kycStatus: "not_submitted"));
                          break;

                        case "Privacy Policy":
                          Get.to(() => PrivacyPolicyScreen());
                          break;

                        case "Terms & Condition":
                          Get.to(() => TermsAndConditionsScreen());
                          break;
                        case "Log Out":
                          controller.confirmLogout();
                          break;

                        default:
                          print("Clicked $title");
                      }
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
