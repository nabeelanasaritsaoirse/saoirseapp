// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/notification_details/notification_details_screen.dart';

import '../../constants/app_strings.dart';
import '../../models/notification_response.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_appbar.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_text.dart';
import 'notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = Get.find<NotificationController>();

  @override
void initState() {
  super.initState();
  final controller = Get.find<NotificationController>();
  controller.refreshNotifications();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: AppStrings.notification_titile,
        showBack: true,
      ),
      body: Obx(() {
        /// LOADING FIRST TIME
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return Center(child: appLoader());
        }

        /// NO NOTIFICATIONS
        if (controller.notifications.isEmpty) {
          return const Center(child: Text("No notifications available"));
        }

        return NotificationList(controller);
      }),
    );
  }
}

/// NOTIFICATION LIST UI
class NotificationList extends StatelessWidget {
  final NotificationController controller;

  const NotificationList(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationInfiniteScroll(
      controller: controller,
      child: ListView.builder(
        padding: EdgeInsets.all(16.r),
        itemCount: controller.notifications.length +
            (controller.hasMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          /// SHOW LOADER AT END WHILE PAGINATING
          if (index == controller.notifications.length) {
            return Padding(
              padding: EdgeInsets.all(16.r),
              child: Center(child: appLoader()),
            );
          }

          final item = controller.notifications[index];

          return NotificationCard(item);
        },
      ),
    );
  }
}

/// CARD WIDGET
class NotificationCard extends StatelessWidget {
  final AppNotification item;

  const NotificationCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final date = item.publishedAt.split("T").first;

    return GestureDetector(
      onTap: () => Get.to(NotificationDetailsScreen(notificationId: item.id),),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 7,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            appText(
              date,
              color: AppColors.darkGray,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      item.imageUrl!,
                      width: 70.w,
                      height: 70.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                  SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title + Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: appText(
                                textAlign: TextAlign.start,
                                item.title,
                                // overflow: TextOverflow.ellipsis,
                                color: AppColors.black,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                maxLines: null),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
      
                      /// Message
                      appText(
                        item.body,
                        textAlign: TextAlign.start,
                        // overflow: TextOverflow.ellipsis,
                        maxLines: null,
                        color: AppColors.darkGray,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 4.h),
                    ],
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

/// INFINITE SCROLL (pagination)
class NotificationInfiniteScroll extends StatefulWidget {
  final Widget child;
  final NotificationController controller;

  const NotificationInfiniteScroll({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  State<NotificationInfiniteScroll> createState() =>
      _NotificationInfiniteScrollState();
}

class _NotificationInfiniteScrollState
    extends State<NotificationInfiniteScroll> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          widget.controller.hasMore.value &&
          !widget.controller.isLoading.value) {
        widget.controller.fetchNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(controller: scrollController, child: widget.child);
  }
}
