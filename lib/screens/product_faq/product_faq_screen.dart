import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_loader.dart';
import '../product_details/product_details_controller.dart';

class ProductFaqScreen extends StatelessWidget {
  final String productId;
  const ProductFaqScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final ProductDetailsController controller =
        Get.find<ProductDetailsController>(tag: productId);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: appText(
          "FAQs",
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
        ),
      ),
      body: Obx(() {
        if (controller.isFaqLoading.value) {
          return Center(child: appLoader());
        }

        if (controller.faqs.isEmpty) {
          return Center(
            child: Container(
              margin: EdgeInsets.all(20.w),
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(14.r),
              ),
              alignment: Alignment.center,
              child: appText(
                "No FAQs available for this product",
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= FAQ LIST =================
              ...List.generate(
                controller.faqs.length,
                (index) {
                  final faq = controller.faqs[index];
                  final isOpen = controller.expandedFaqIndex.value == index;

                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appText(
                              (index + 1).toString().padLeft(2, '0'),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: appText(
                                faq.question,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.left,
                                fontSize: 13.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.expandedFaqIndex.value =
                                    isOpen ? -1 : index;
                              },
                              child: Icon(
                                isOpen ? Icons.remove : Icons.add,
                                size: 24.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),

                        /// ================= ANSWER =================
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: isOpen
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.h, left: 28.w),
                                  child: appText(
                                    faq.answer,
                                    textAlign: TextAlign.left,
                                    fontSize: 12.sp,
                                    color: AppColors.textBlack,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
