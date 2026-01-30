import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/product_details/product_details_controller.dart';

import '../constants/app_colors.dart';

import 'app_text.dart';

class WriteReviewDialog extends StatelessWidget {
  final String productId;
  WriteReviewDialog({super.key, required this.productId});

  late final ProductDetailsController controller =
      Get.find<ProductDetailsController>(tag: productId);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
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
            Obx(() => Row(
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
                )),

            SizedBox(height: 14.h),

            // ================= ADD IMAGE =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 5.w,
                  children: [
                    appText("Add Image",
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack),
                    appText("(Max 5)",
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: controller.pickReviewImages,
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    size: 16.sp,
                  ),
                  label: appText(
                    "Add Image",
                    color: AppColors.lightBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.lightBlue,
                    side: BorderSide(
                      color: AppColors.lightBlue, // 👈 BORDER COLOR
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                  ),
                ),
              ],
            ),

            // ================= IMAGE PREVIEW (CONDITIONAL) =================
            Obx(() {
              if (controller.reviewImages.isEmpty) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: SizedBox(
                  height: 70.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.reviewImages.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (_, index) {
                      return Stack(
                        clipBehavior: Clip.none,
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
                            right: 5.w,
                            child: GestureDetector(
                              onTap: () => controller.removeReviewImage(index),
                              child: Container(
                                width: 18.w,
                                height: 18.w,
                                decoration: BoxDecoration(
                                  color: AppColors.mediumGray,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: 14.sp,
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
              );
            }),

            SizedBox(height: 14.h),

            // ================= REVIEW TEXT FIELD =================
            TextField(
              maxLines: 4,
              onChanged: controller.updateReviewText,
              decoration: InputDecoration(
                hintText: "write your valuable feedback.",
                hintStyle: TextStyle(
                  color: AppColors.grey,
                  fontSize: 12.sp,
                ),
                contentPadding: EdgeInsets.all(12.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: AppColors.grey),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // ================= ACTION BUTTONS =================
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.resetReviewForm();
                      Get.back();
                    },
                    child: appText(
                      "Cancel",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      // TODO: Submit review API
                      controller.resetReviewForm();
                      Get.back();
                    },
                    child: appText(
                      "Save",
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
