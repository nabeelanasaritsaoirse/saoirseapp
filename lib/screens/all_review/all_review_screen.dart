// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/models/review_resposne.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import 'all_review_controller.dart';

class AllReviewsScreen extends StatelessWidget {
  final String productId;
  AllReviewsScreen({super.key, required this.productId}) {
    Get.put(AllReviewsController(productId: productId,
    
    ),
    permanent: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AllReviewsController>();
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
            _buildRatingSummary(controller),
            SizedBox(height: 14.h),
            _buildImageRow(controller),
            SizedBox(height: 16.h),
            appText(
              "All Users",
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 10.h),
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: appLoader());
              }

              if (controller.reviews.isEmpty) {
                return appText(
                  "No reviews available",
                  color: AppColors.grey,
                );
              }

              return Column(
                children: controller.reviews
                    .map((review) => _buildReviewCard(review))
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ================= RATING SUMMARY =================
  Widget _buildRatingSummary(AllReviewsController controller) {
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
            Obx(() => _buildStarRow(controller.averageRating.value)),
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
  Widget _buildStarRow(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.round() ? Icons.star : Icons.star_border,
          size: 18.sp, // same size you already use here
          color: AppColors.lightAmber,
        );
      }),
    );
  }

  
  Widget _buildImageRow(AllReviewsController controller) {
    return Obx(() {
      if (controller.reviewImages.isEmpty) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 70.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.reviewImages.length,
          separatorBuilder: (_, __) => SizedBox(width: 8.w),
          itemBuilder: (_, index) {
            final url = controller.reviewImages[index];

            return ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                height: 70.h,
                width: 80.w,
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: AppColors.lightGrey,
                      alignment: Alignment.center,
                      child: appLoader(),
                    );
                  },
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
            );
          },
        ),
      );
    });
  }

 
  Widget _buildReviewCard(Review review) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 12.sp, color: AppColors.lightAmber),
                    SizedBox(width: 2.w),
                    appText(
                      review.rating.toStringAsFixed(1),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: appText(
                  review.title,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              appText(
                _timeAgo(review.createdAt),
                fontSize: 11.sp,
                color: AppColors.grey,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          appText(
            review.comment,
            textAlign: TextAlign.left,
            fontSize: 12.sp,
            color: AppColors.textBlack,
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 30) return "${diff.inDays ~/ 30} months ago";
    if (diff.inDays > 0) return "${diff.inDays} days ago";
    if (diff.inHours > 0) return "${diff.inHours} hours ago";
    return "Just now";
  }
}
