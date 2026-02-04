import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../screens/order_delivered/write_review_controller/write_review_controller.dart';
import 'app_text.dart';

class WriteReviewDialog extends StatelessWidget {
  final String productId;
  const WriteReviewDialog({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WriteReviewController>(tag: productId);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appText(
                    "Rate your Experience",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.resetReviewForm();
                      Get.back();
                    },
                    child: const Icon(Icons.close),
                  )
                ],
              ),

              SizedBox(height: 16.h),

              // ================= STAR RATING =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  final isSelected = index < controller.reviewRating.value;

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => controller.setReviewRating(index + 1),
                        child: Icon(
                          Icons.star_rounded,
                          size: 36.sp,
                          color: isSelected
                              ? AppColors.lightAmber
                              : AppColors.shadeGray,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      appText(
                        controller.reviewRatingLabels[index],
                        fontSize: 10.sp,
                        color: AppColors.grey,
                      )
                    ],
                  );
                }),
              ),

              SizedBox(height: 14.h),

              // ================= ADD IMAGE =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      appText(
                        "Add Image",
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(width: 6.w),
                      appText(
                        "(Max 5)",
                        fontSize: 10.sp,
                        color: AppColors.grey,
                      ),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: controller.isUploadingImages.value
                        ? null
                        : controller.pickReviewImages,
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 16.sp,
                    ),
                    label: appText(
                      "Add Image",
                      fontSize: 12.sp,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ],
              ),

              // ================= IMAGE PREVIEW =================
              if (controller.reviewImages.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: SizedBox(
                    height: 70.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.reviewImages.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      itemBuilder: (_, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.file(
                                File(controller.reviewImages[index].path),
                                width: 70.w,
                                height: 70.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4.h,
                              right: 4.w,
                              child: GestureDetector(
                                onTap: () =>
                                    controller.removeReviewImage(index),
                                child: Container(
                                  width: 18.w,
                                  height: 18.w,
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 12.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

              SizedBox(height: 14.h),

              // ================= REVIEW TEXT =================
              TextField(
                maxLines: 4,
                onChanged: controller.updateReviewText,
                decoration: InputDecoration(
                  hintText: "Write your valuable feedback",
                  hintStyle: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),

              // ================= UPLOADING STATE =================
              if (controller.isUploadingImages.value)
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      appText(
                        "Uploading images...",
                        fontSize: 12.sp,
                        color: AppColors.grey,
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 16.h),

              // ================= ACTION BUTTONS =================
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.isUploadingImages.value
                          ? null
                          : () {
                              controller.resetReviewForm();
                              Get.back();
                            },
                      child: appText("Cancel"),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: controller.reviewRating.value == 0 ||
                              controller.isUploadingImages.value
                          ? null
                          : () async {
                              final success = await controller.submitReview();

                              if (success) {
                                Get.back(); // ✅ close dialog ONLY on success
                              }
                            },
                      child: appText(
                        controller.isUploadingImages.value
                            ? "Submitting..."
                            : "Submit Review",
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


