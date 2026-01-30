// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import 'all_review_controller.dart';

class AllReviewsScreen extends StatelessWidget {
  AllReviewsScreen({super.key});

  final AllReviewsController controller = Get.put(AllReviewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "All Reviews",
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingSummary(),
            SizedBox(height: 14.h),
            _buildImageRow(),
            SizedBox(height: 16.h),
            appText(
              "All Users",
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 10.h),
            ...controller.reviews.map(_buildReviewCard),
          ],
        ),
      ),
    );
  }

  // ================= RATING SUMMARY =================
  Widget _buildRatingSummary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => appText(
              controller.averageRating.value.toStringAsFixed(1),
              fontSize: 34.sp,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appText(
              "OUT OF 5",
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.grey,
            ),
            SizedBox(height: 4.h),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildStarRow(5),
            SizedBox(height: 6.h),
            Obx(() => appText(
                  "${controller.totalRatings.value} ratings",
                  fontSize: 11.sp,
                  color: AppColors.grey,
                )),
          ],
        )
      ],
    );
  }

  // ================= STAR ROW =================
  Widget _buildStarRow(int count) {
    return Row(
      children: List.generate(
        count,
        (_) => Icon(
          Icons.star,
          size: 18.sp,
          color: AppColors.lightAmber,
        ),
      ),
    );
  }

  // ================= IMAGE ROW =================
  Widget _buildImageRow() {
    return Obx(() => SizedBox(
          height: 70.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.reviewImages.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (_, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 70.h,
                      width: 80.w,
                      child: Image.network(
                        controller.reviewImages[index],
                        fit: BoxFit.cover,

                        // 👇 PER IMAGE LOADER
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // image loaded
                          }
                          return Container(
                            color: AppColors.lightGrey,
                            alignment: Alignment.center,
                            child: appLoader(), // small loader
                          );
                        },

                        // 👇 optional error UI
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.lightGrey,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.broken_image,
                            size: 20.sp,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ),

                    // +N overlay
                    if (index == controller.reviewImages.length - 1 &&
                        controller.reviewImages.length > 3)
                      Container(
                        height: 70.h,
                        width: 80.w,
                        alignment: Alignment.center,
                        color: Colors.black.withOpacity(0.5),
                        child: appText(
                          "+${controller.reviewImages.length - 3}",
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  // ================= REVIEW CARD =================
  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 12.sp,
                      color: AppColors.lightAmber,
                    ),
                    SizedBox(width: 2.w),
                    appText(
                      review["rating"].toString(),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              appText(
                review["title"],
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              appText(
                review["time"],
                fontSize: 11.sp,
                color: AppColors.grey,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          appText(
            review["message"],
            textAlign: TextAlign.left,
            fontSize: 12.sp,
            color: AppColors.textBlack,
          ),
        ],
      ),
    );
  }
}
