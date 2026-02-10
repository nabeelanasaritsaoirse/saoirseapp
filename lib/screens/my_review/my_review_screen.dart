import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/models/own_review_resposne_model.dart';
import 'package:saoirse_app/screens/my_review/my_review_controller.dart';
import 'package:saoirse_app/screens/order_delivered/write_review_controller/write_review_controller.dart';
import 'package:saoirse_app/widgets/app_text.dart';
import 'package:saoirse_app/widgets/custom_appbar.dart';
import 'package:saoirse_app/widgets/write_review_dialog.dart';

import '../../constants/app_colors.dart';

class MyReviewScreen extends StatelessWidget {
  final MyReviewController controller = Get.put(MyReviewController());

  MyReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "My Reviews",
        showBack: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reviews.isEmpty) {
          return const Center(child: Text("No reviews found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.reviews.length,
          itemBuilder: (context, index) {
            final review = controller.reviews[index];
            return _buildReviewCard(review);
          },
        );
      }),
    );
  }

  // ================= REVIEW CARD =================
  Widget _buildReviewCard(Review review) {
    final remaining = controller.remainingEdits(review);
    final canEdit = controller.canEdit(review);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Rating + title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star,
                        size: 12, color: AppColors.lightAmber),
                    const SizedBox(width: 2),
                    appText(
                      review.rating.toStringAsFixed(1),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: appText(
                  review.title,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              appText(
                _timeAgo(review.createdAt!),
                fontSize: 11,
                color: AppColors.grey,
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Comment
          appText(
            review.comment,
            // "I’ve been using this product for a while now, and overall I’m quite satisfied with the experience. From the moment I received it, the packaging felt secure and well thought out, which gave a good first impression. The product itself looks premium and feels sturdy, so it doesn’t come across as cheap or poorly made.",
            textAlign: TextAlign.left,
            fontSize: 12,
            color: AppColors.textBlack,
          ),

          const SizedBox(height: 8),

          /// Images
          /// Images
          if (review.images.isNotEmpty) ...[
            SizedBox(height: 10.h),
            SizedBox(
              height: 70.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length > 3 ? 3 : review.images.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final image = review.images[index];
                  final totalImages = review.images.length;

                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          image.thumbnail ?? image.url,
                          width: 70.w,
                          height: 70.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Icon(Icons.broken_image, size: 24.sp),
                        ),
                      ),

                      /// Overlay on 3rd image if more exist
                      if (index == 2 && totalImages > 3)
                        Container(
                          width: 70.w,
                          height: 70.h,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          alignment: Alignment.center,
                          child: appText(
                            "+${totalImages - 3}",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 10),

          /// Edit button
          Row(
            children: [
              /// Left side text section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (canEdit)
                      appText(
                        "$remaining edits remaining",
                        fontSize: 11.sp,
                        color: AppColors.grey,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      appText(
                        "Edit limit reached",
                        fontSize: 11.sp,
                        color: Colors.red,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (review.editCount == 2)
                      appText(
                        "This is your last edit",
                        fontSize: 11.sp,
                        color: Colors.orange,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              /// Edit button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w, // increased width
                    vertical: 4.h, // slightly taller
                  ),
                  minimumSize: Size(0, 30.h), // increased height
                  side: BorderSide(
                    color: AppColors.grey, // your purple color
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: canEdit
                    ? () {
                        final writeController = Get.put(
                          WriteReviewController(productId: review.product),
                          tag: review.product,
                        );

                        writeController.loadExistingReview(review);

                        Get.dialog(
                          WriteReviewDialog(productId: review.product),
                        );
                      }
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 12.sp,
                      color: AppColors.textBlack,
                    ),
                    SizedBox(width: 5.w),
                    appText(
                      "Edit",
                      fontSize: 11.sp,
                      color: AppColors.textBlack,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ================= TIME AGO =================
  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 30) return "${diff.inDays ~/ 30} months ago";
    if (diff.inDays > 0) return "${diff.inDays} days ago";
    if (diff.inHours > 0) return "${diff.inHours} hours ago";
    return "Just now";
  }
}
