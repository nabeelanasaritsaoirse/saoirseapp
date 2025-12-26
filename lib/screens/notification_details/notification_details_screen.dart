import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saoirse_app/screens/notification/notification_controller.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../models/notification_details_response_model.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final String notificationId;

  const NotificationDetailsScreen({super.key, required this.notificationId});

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  final NotificationController controller = Get.find<NotificationController>();
  final TextEditingController commentCtrl = TextEditingController();


  @override
  void initState() {
    super.initState();
     controller.markAsRead(widget.notificationId);
    controller.getNotificationDetails(widget.notificationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Notification Details",
            style: TextStyle(color: Colors.white)),
      ),
      body: Obx(() {
        if (controller.isDetailsLoading.value) {
          return Center(child: appLoader());
        }

        final item = controller.notificationDetails.value;

        if (item == null) {
          return const Center(child: Text("No Details Available"));
        }

        final date = item.publishedAt.split("T").first;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                   ClipRRect(
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(20.r),
    bottomRight: Radius.circular(20.r),
  ),
  child: Image.network(
    item.imageUrl!,
    width: double.infinity,
    height: 220.h,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }
      return Center(
        child: CupertinoActivityIndicator(
          radius: 10.0,
          color: AppColors.textGray,
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) => Container(
      color: Colors.grey.shade300,
      child: Center(
        child: Icon(
          Icons.broken_image,
          size: 40.sp,
          color: Colors.grey.shade600,
        ),
      ),
    ),
  ),
),

                  SizedBox(height: 20.h),

                  /// MAIN CARD
                  _mainCard(item, date),

                  SizedBox(height: 20.h),

                  /// COMMENTS SECTION
                  _commentSection(),
                ],
              ),
            ),
            _commentInputBar(),
          ],
        );
      }),
    );
  }

  /// --- MAIN CARD ---
  Widget _mainCard(NotificationModel item, String date) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + date
          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: appText(
                  item.title,
                  fontSize: 18.sp,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  maxLines: null,
                ),
              ),
            ],
          ),

          Align(
            alignment: AlignmentGeometry.centerRight,
            child: appText(
              date,
              fontSize: 13.sp,
              color: AppColors.darkGray,
            ),
          ),
          SizedBox(height: 4.h),
          appText(
            item.body,
            fontSize: 14.sp,
            color: AppColors.darkGray,
            textAlign: TextAlign.start,
          ),

          SizedBox(height: 20.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               GestureDetector(
                onTap: () => controller.toggleLike(item.id),
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: item.isLikedByMe ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        item.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                        color: item.isLikedByMe ? Colors.red : AppColors.primaryColor,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    appText(
                      "${item.likeCount} Likes",
                      color: AppColors.darkGray,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              _buildStat(Icons.comment_outlined, "Comments", item.commentCount),
              _buildStat(
                  Icons.remove_red_eye_outlined, "Views", item.viewCount),
            ],
          ),
        ],
      ),
    );
  }

  /// --- COMMENTS SECTION ---
  Widget _commentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: appText(
            "Comments",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 10.h),
        Obx(() {
          if (controller.comments.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: appText(
                "No comments yet",
                color: AppColors.darkGray,
                fontSize: 13.sp,
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.comments.length,
            itemBuilder: (context, index) {
              final c = controller.comments[index];
              return _commentItem(c);
            },
          );
        }),
      ],
    );
  }

  /// COMMENT ITEM UI
  Widget _commentItem(CommentModel c) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Name
          appText(
            c.userName ?? "",
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: AppColors.black,
          ),

          SizedBox(height: 4.h),

          /// Text
          appText(c.text ?? "",
              fontSize: 13.sp,
              color: AppColors.darkGray,
              textAlign: TextAlign.left),

          SizedBox(height: 4.h),

          /// Date
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: appText(
              (c.createdAt ?? "").split("T").first,
              fontSize: 11.sp,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, int count) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20.sp),
        SizedBox(width: 6.w),
        appText("$count $label",
            color: AppColors.darkGray,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500),
      ],
    );
  }

  /// COMMENT INPUT BOX
 Widget _commentInputBar() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentCtrl,
              maxLines: 2,
              minLines: 1,
              decoration: InputDecoration(
                hintText: "Write a comment...",
                filled: true,
                fillColor: AppColors.scaffoldColor,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          Obx(() {
            return controller.isLoading.value
                ? SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: appLoader()
                  )
                : GestureDetector(
                    onTap: () async {
                      final text = commentCtrl.text.trim();
                      if (text.isEmpty) return;

                      await controller.addComment(
                        widget.notificationId,
                        text,
                      );

                      commentCtrl.clear();
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 22.r,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  );
          }),
        ],
      ),
    ),
  );
}

}








