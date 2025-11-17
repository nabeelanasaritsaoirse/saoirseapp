import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../widgets/app_text.dart';
import 'category_controller.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final CategoryController controller = Get.put(CategoryController());

  Widget _iconBox({required String image, required double padding}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.h),
      width: 36.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Image.asset(image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: appText(
          "Categories",
          fontSize: 19.sp,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          _iconBox(image: AppAssets.search, padding: 9.w),
          SizedBox(width: 8.w),
          _iconBox(image: AppAssets.wish, padding: 8.w),
          SizedBox(width: 8.w),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar with proper reactive rebuild
          Container(
            width: 80.h,
            color: AppColors.white,
            child: Obx(
              () => ListView.builder(
                key: ValueKey(controller.selectedIndex.value),
                controller: controller.scrollController.value,
                itemCount: controller.categoryGroups.length,
                itemBuilder: (context, index) {
                  final isSelected = controller.selectedIndex.value == index;
                  final category = controller.categoryGroups[index];

                  return GestureDetector(
                    key: ValueKey(category.name),
                    onTap: () => controller.selectCategory(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.lightGrey : AppColors.white,
                        border: Border(
                          left: BorderSide(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.transparent,
                            width: 4.w,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 7.w,
                      ),
                      child: Column(
                        children: [
                          Image.asset(category.icon, width: 70.w, height: 70.h),
                          SizedBox(height: 7.h),
                          appText(
                            category.name,
                            textAlign: TextAlign.center,
                            fontSize: 11.sp,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.textBlack,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Right Grid View of Subcategories
          Expanded(
            child: Obx(
              () => GridView.builder(
                key: ValueKey(controller.selectedIndex.value),
                padding: EdgeInsets.all(15.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 11.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.77, 
                ),
                itemCount: controller.selectedSubCategories.length,
                itemBuilder: (context, index) {
                  final subCategory = controller.selectedSubCategories[index];
                  return SubCategoryCard(subCategory: subCategory);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubCategoryCard extends StatelessWidget {
  final SubCategory subCategory;

  const SubCategoryCard({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 200.w,
              height: 95.h,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 5.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Image.asset(
                subCategory.image,
                width: 70.w,
                height: 70.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.image,
                      size: 40.sp,
                      color: AppColors.lightGrey,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),
            appText(
              subCategory.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
