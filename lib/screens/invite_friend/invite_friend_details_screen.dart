import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/widgets/app_loader.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/friend_details_response.dart';
import '../../screens/invite_friend/invite_friend_controller.dart';
import '../../widgets/app_button.dart';
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
      backgroundColor: AppColors.white,
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
                constraints: BoxConstraints(minHeight: 140.h),
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // LEFT SIDE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 6.h,
                      children: [
                        appText(
                          user.name,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                        SizedBox(
                          width: 200.w,
                          child: appText(user.email,
                              fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textBlack, maxLines: 2, textAlign: TextAlign.start),
                        ),
                        SizedBox(height: 10.h),
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

                    // RIGHT SIDE (PROFILE PICTURE + MESSAGE)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 8.h,
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: user.profilePicture.isNotEmpty
                                  ? NetworkImage(user.profilePicture)
                                  : AssetImage(AppAssets.profile_image) as ImageProvider,
                            ),
                          ),
                        ),
                        appButton(
                          onTap: () {
                            controller.openChat(name: user.name);
                          },
                          width: 89.w,
                          height: 27.h,
                          padding: EdgeInsets.all(5.w),
                          buttonColor: AppColors.mediumAmber,
                          borderColor: AppColors.darkGray,
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

              SizedBox(height: 10.h),
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
