import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/app_constant.dart';
import '../../constants/app_urls.dart';
import '../../main.dart';
import '../../widgets/app_button.dart';
import '../coupon/coupon_screen.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../faqs/faqs.dart';
import '../kyc/kyc_controller.dart';
import '../kyc/kyc_screen.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/profile_menu_card.dart';
import '../login/login_page.dart';
import '../manage_address/manage_address_screen.dart';
import '../order_delivered/order_delivered_screen.dart';
import '../order_history/order_history_screen.dart';
import '../orders_active/orders_active_screen.dart';
import '../pending_transaction/pending_transaction_screen.dart';
import '../select_account/managa_account.dart';
import '../transaction_history/transaction_history.dart';
import '../wishlist/wishlist_screen.dart';
import 'profile_controller.dart';
import '../autopay/autopay_dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController controller;
  final kyccontroller = Get.find<KycController>();

  @override
  void initState() {
    controller = Get.find<ProfileController>();
    super.initState();
  }

  bool get isLoggedIn {
    return storage.read(AppConst.USER_ID) != null;
  }

  Widget _loginOnlyView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appText(
              "Please login to view your Profile",
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 20.h),
            appButton(
              buttonColor: AppColors.primaryColor,
              onTap: () async {
                await Get.to(() => LoginPage());
                if (isLoggedIn) {
                  controller.fetchUserProfile();
                  controller.fetchWishlistCount();
                  controller.fetchDeleteInfo();
                }
              },
              child: appText(
                "Login",
                color: AppColors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      //
      appBar: _profileAppBar(),
      body: !isLoggedIn
          ? _loginOnlyView()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------------------- PROFILE BANNER -----------------------

                  Obx(() {
                    if (controller.isLoading.value) {
                      return SizedBox(
                        height: 200,
                        child: Center(child: appLoader()),
                      );
                    }

                    final profile = controller.profile.value;

                    if (profile == null) {
                      return SizedBox(
                        height: 200,
                        child: Center(child: Text("Failed to load profile")),
                      );
                    }

                    final user = profile.user;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
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
                        Positioned(
                          top: 39.h,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Profile image
                                  CircleAvatar(
                                    radius: 42,
                                    backgroundColor: Colors.grey.shade300,
                                    child: user.profilePicture.isNotEmpty
                                        ? ClipOval(
                                            child: Image.network(
                                              user.profilePicture,
                                              fit: BoxFit.cover,
                                              width: 84,
                                              height: 84,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                    radius: 10.0,
                                                    color: AppColors.textGray,
                                                  ),
                                                );
                                              },
                                              errorBuilder: (_, __, ___) =>
                                                  ClipOval(
                                                child: Image.asset(
                                                  AppAssets.user_img,
                                                  fit: BoxFit.cover,
                                                  width: 84,
                                                  height: 84,
                                                ),
                                              ),
                                            ),
                                          )
                                        : ClipOval(
                                            child: Image.asset(
                                              AppAssets.user_img,
                                              fit: BoxFit.cover,
                                              width: 84,
                                              height: 84,
                                            ),
                                          ),
                                  ),

                                  Positioned(
                                    right: -2,
                                    bottom: -2,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => EditProfileScreen());
                                      },
                                      child: Container(
                                        width: 28.w,
                                        height: 28.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.edit,
                                            size: 16.sp,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              appText(
                                user.name,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBlack,
                                fontSize: 18.sp,
                              ),
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
                                  count: controller
                                      .wishlistCount.value, // 🔥 reactive
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
                                Get.to(() => PendingTransaction());
                              } else if (index == 1) {
                                Get.to(() => OrderHistoryScreen());
                              } else if (index == 2) {
                                Get.to(() => WishlistScreen());
                              } else if (index == 3) {
                                Get.to(() => OrdersActiveScreen());
                              } else if (index == 4) {
                                Get.to(() => TransactionHistory());
                              } else if (index == 5) {
                                Get.to(() => OrderDeliveredScreen());
                              } else if (index == 6) {
                                Get.to(() => AutopayDashboardScreen());
                              } else if (index == 7) {
                                Get.to(() => CouponScreen());
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
                                Get.to(() => KycScreen());
                                break;
                              case "Manage Account":
                                Get.to(() => ManageAccountScreen());
                                break;
                              case "Manage Address":
                                Get.to(() => ManageAddressScreen());
                              case "FAQs":
                                Get.to(() => FaqScreen());
                                break;
                              case "Privacy Policy":
                                controller.openUrl(AppURLs.PRIVACY_POLICY);
                                break;
                              case "Terms & Condition":
                                controller
                                    .openUrl(AppURLs.TERMS_AND_CONDITIONS);
                                break;
                              case "Contact Us":
                                controller.openUrl(AppURLs.CONTACT_US);
                                break;
                              // case "Log Out":
                              //   controller.confirmLogout();
                              //   break;
                              // case "Delete\nAccount":
                              //   controller.deleteAccount();
                              //   break;

                              default:
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

  PreferredSizeWidget _profileAppBar() {
    return CustomAppBar(
      title: AppStrings.profile_title,
      showBack: false,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: AppColors.white,
          ),
          offset: const Offset(0, 45),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            if (value == "logout") {
              controller.confirmLogout();
            } else if (value == "delete") {
              controller.deleteAccount();
            }
          },
          itemBuilder: (context) => [
            _menuItem(
              value: "logout",
              title: "Logout",
              iconPath: AppAssets.logout_menu,
            ),
            _menuItem(
              value: "delete",
              title: "Delete Account",
              iconPath: AppAssets.delete_menu,
            ),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _menuItem({
    required String value,
    required String title,
    required String iconPath,
    Color? bgColor,
  }) {
    return PopupMenuItem<String>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: SvgPicture.asset(
                iconPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
