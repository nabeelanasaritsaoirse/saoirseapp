import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/constants/app_strings.dart';
import 'package:saoirse_app/widgets/app_text.dart';
import 'package:saoirse_app/widgets/custom_appbar.dart';
import 'faq_controller.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});

  final FaqController controller = Get.put(FaqController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        title: AppStrings.FAQsTitle,
        showBack: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appText(
              'Know More About EPI',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),

            SizedBox(height: 6.h),
            appText(
              'Curious about our services?\nHere’s everything you need to know before you start saving smartly.',
              fontSize: 15.sp,
              color: AppColors.mediumGray,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 20.h),

            /// FAQ LIST
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.separated(
                  itemCount: controller.faqList.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final faq = controller.faqList[index];

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => controller.toggleExpand(index),
                      child: Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Obx(() {
                          final isExpanded =
                              controller.expandedIndex.value == index;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  appText(
                                    (index + 1).toString().padLeft(2, '0'),
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  SizedBox(width: 10.w),
                                  appText(
                                    faq.question,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  Icon(isExpanded ? Icons.remove : Icons.add,
                                      size: 22.sp,
                                      color: AppColors.primaryColor),
                                ],
                              ),

                              /// ANSWER
                              AnimatedSize(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                child: isExpanded
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          left: 26.w,
                                          top: 12.h,
                                        ),
                                        child: appText(
                                          faq.answer,
                                          fontSize: 13.sp,
                                          color: AppColors.darkGray,
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          );
                        }),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
