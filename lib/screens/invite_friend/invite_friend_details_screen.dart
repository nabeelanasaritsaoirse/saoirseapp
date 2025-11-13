import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_assets.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import 'package:saoirse_app/models/invite_friend_product_model.dart';
import 'package:saoirse_app/screens/invite_friend/invite_friend_controller.dart';
import 'package:saoirse_app/widgets/app_button.dart';
import 'package:saoirse_app/widgets/app_text.dart';
import 'package:saoirse_app/widgets/product_details_dialog.dart';

class InviteFriendDetailsScreen extends StatelessWidget {
  const InviteFriendDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InviteFriendController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: appText(
          AppStrings.refferal_details,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              height: 120.h,
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 2.h,
                    children: [
                      appText(
                        AppStrings.user_name,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                      appText(
                        AppStrings.user_email,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        spacing: 8.w,
                        children: [
                          appButton(
                            onTap: () {},
                            width: 96.w,
                            padding: EdgeInsets.all(6.w),
                            height: 38.h,
                            borderRadius: BorderRadius.circular(10.r),
                            buttonColor: AppColors.buttonSecondary,
                            child: Column(
                              children: [
                                appText(
                                  AppStrings.total_product,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                appText(
                                  "2",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                          appButton(
                            onTap: () {},
                            width: 96.w,
                            padding: EdgeInsets.all(6.w),
                            height: 38.h,
                            borderRadius: BorderRadius.circular(10.r),
                            buttonColor: AppColors.mediumGreen,
                            child: Column(
                              children: [
                                appText(
                                  AppStrings.my_commission,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                appText(
                                  "₹840",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Right side (profile)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 6.h,
                    children: [
                      Container(
                        width: 75.w,
                        height: 75.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(AppAssets.profile_image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      appButton(
                        onTap: () {},
                        width: 89.w,
                        height: 25.h,
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

            Divider(color: AppColors.grey),
            SizedBox(height: 8.h),

            // Product Section
            appText(
              AppStrings.product,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 10.h),

            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.products.isEmpty) {
                return Center(
                  child: appText(
                    AppStrings.no_products,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                  ),
                );
              }

              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.products.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final product = controller.products[index];
                  return _buildProductCard(context, product);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Product Card Widget
Widget _buildProductCard(
    BuildContext context, InviteFriendProductModel product) {
  final isPending = product.pendingCount > 0;

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
        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appText(
              product.productName,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
            appText(
              "${AppStrings.dp}${product.date}",
              fontSize: 12.sp,
              color: AppColors.darkGray,
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Product ID and Amount
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
                  "₹${product.amount.toStringAsFixed(0)}",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 5.h),

        // Pending Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5.w,
              children: [
                appText(
                  AppStrings.pending_status,
                  fontSize: 13.sp,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
                appText(
                  "${product.pendingCount} ${product.pendingLabel}",
                  fontSize: 13.sp,
                  color: isPending ? AppColors.red : AppColors.green,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            SizedBox(
              width: 105.w,
              height: 25.h,
              child: appButton(
                padding: EdgeInsets.all(0.w),
                borderRadius: BorderRadius.circular(6.r),
                onTap: () => showProductDetailsDialog(context, product),
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
