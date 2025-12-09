// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/friend_details_response.dart';
import '../../screens/invite_friend/invite_friend_controller.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/product_details_dialog.dart';

class InviteFriendDetailsScreen extends StatelessWidget {
  final String userId;

  const InviteFriendDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InviteFriendController(userId));

    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: CustomAppBar(
        title: AppStrings.refferal_details,
        showBack: true,
      ),

      // ---------------- BODY ----------------
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: appLoader());
        }

        final user = controller.friendDetails.value;

        if (user == null) {
          return Center(
            child: appText(
              "No data found",
              fontSize: 14.sp,
              color: AppColors.grey,
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- HEADER ----------------
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE3F2FD).withOpacity(0.6), 
                      Color(0xFFF3E5F5).withOpacity(0.6), 
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 2,
                  ),
                  boxShadow: [
                    // Top shadow
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: Offset(0, -4),
                    ),
                    // Bottom shadow
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(0, 8),
                    ),
                    // Left shadow
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: Offset(-4, 0),
                    ),
                    // Right shadow
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: Offset(4, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // LEFT SIDE - Name and Buttons
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 200.w,
                            height: 40.h,
                            alignment: Alignment.center,
                            child: appText(
                              user.name,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlack,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          // Buttons Row
                          Row(
                            spacing: 8.w,
                            children: [
                              // Total Products
                              appButton(
                                onTap: () {},
                                width: 96.w,
                                height: 45.h,
                                padding: EdgeInsets.all(6.w),
                                borderRadius: BorderRadius.circular(10.r),
                                buttonColor: AppColors.buttonSecondary,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      appText(
                                        AppStrings.total_product,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      appText(
                                        "${user.totalProducts}",
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Total Commission
                              appButton(
                                onTap: () {},
                                width: 96.w,
                                height: 45.h,
                                padding: EdgeInsets.all(6.w),
                                borderRadius: BorderRadius.circular(10.r),
                                buttonColor: AppColors.mediumGreen,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      appText(
                                        AppStrings.my_commission,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      appText(
                                        "₹${user.totalCommission}",
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Spacer(),

                      // RIGHT SIDE - Profile Picture and Message Button
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 8.h,
                        children: [
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 2,
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: user.profilePicture.isNotEmpty
                                    ? NetworkImage(user.profilePicture)
                                    : AssetImage(AppAssets.user_img) as ImageProvider,
                              ),
                            ),
                          ),
                          appButton(
                            onTap: () {
                              controller.openChat(name: user.name);
                            },
                            width: 89.w,
                            height: 32.h,
                            padding: EdgeInsets.all(5.w),
                            buttonColor: AppColors.mediumAmber,
                            borderColor: AppColors.darkGray,
                            borderRadius: BorderRadius.circular(10.r),
                            child: Center(
                              child: appText(
                                AppStrings.message,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4.h),
              Divider(color: AppColors.grey),
              SizedBox(height: 10.h),

              // ---------------- PRODUCT TITLE ----------------
              appText(
                AppStrings.product,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 10.h),

              // ---------------- PRODUCT LIST ----------------
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: user.products.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final product = user.products[index];
                  return _buildProductCard(context, product, controller);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ---------------- PRODUCT CARD USING API MODEL ----------------
Widget _buildProductCard(BuildContext context, FriendProduct product, InviteFriendController controller) {
  final bool isPending = product.pendingDays > 0;

  // Format date
  String formattedDate = "";
  try {
    formattedDate = product.dateOfPurchase.substring(0, 10);
  } catch (_) {
    formattedDate = product.dateOfPurchase;
  }

  return Container(
    padding: EdgeInsets.all(10.w),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 6.r,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- Title + Date ----------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appText(
              product.productName,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
            appText(
              "${AppStrings.dp}$formattedDate",
              fontSize: 12.sp,
              color: AppColors.darkGray,
            ),
          ],
        ),

        SizedBox(height: 6.h),

        // ---------------- Product ID + Amount ----------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 5.w,
              children: [
                appText(
                  AppStrings.productId,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey,
                ),
                appText(
                  product.productId,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
            Row(
              spacing: 5.w,
              children: [
                appText(
                  AppStrings.amount,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey,
                ),
                appText(
                  "₹${product.totalAmount}",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 6.h),

        // ---------------- Pending Status + View Button ----------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 5.w,
              children: [
                appText(
                  AppStrings.pending_status,
                  fontSize: 13.sp,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
                appText(
                  "${product.pendingDays} days",
                  fontSize: 13.sp,
                  color: isPending ? AppColors.red : AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            SizedBox(
              width: 105.w,
              height: 25.h,
              child: appButton(
                padding: EdgeInsets.all(0.w),
                borderRadius: BorderRadius.circular(6.r),
                onTap: () async {
                  final productDetails = await controller.getProductDetails(product.productId);

                  if (productDetails != null && Get.context != null) {
                    showProductDetailsDialog(Get.context!, productDetails);
                  }
                },
                buttonColor: AppColors.primaryColor,
                child: Center(
                  child: appText(
                    AppStrings.view_details,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
