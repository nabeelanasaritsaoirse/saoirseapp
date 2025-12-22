import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../constants/app_colors.dart';
import '../models/category_model.dart';
import '../screens/category/category_controller.dart';
import 'app_text.dart';

class CategoryItem extends StatelessWidget {
  final int index;
  final CategoryController controller;

  const CategoryItem({
    super.key,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      final category = controller.categoryGroups[index];

      return InkWell(
          onTap: () => controller.selectCategory(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 7.w),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.lightGrey : AppColors.white,
              border: Border(
                left: BorderSide(
                  color:
                      isSelected ? AppColors.primaryColor : Colors.transparent,
                  width: 4.w,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // FIXED image size = no relayout
                SizedBox(
                  width: 50.w,
                  height: 50.h,
                  child: _CategoryImage(category: category),
                ),

                SizedBox(height: 6.h),

                // FIXED text behavior = no relayout
                Text(
                  category.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.sp,
                    height: 1.2, // 🔥 IMPORTANT
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.textBlack,
                  ),
                ),
              ],
            ),
          ));
    });
  }
}

class _CategoryImage extends StatelessWidget {
  final CategoryGroup category;

  const _CategoryImage({required this.category});

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.image?.url;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Icon(
        Icons.image_outlined,
        size: 32.sp,
        color: AppColors.grey,
      );
    }

    return Image.network(
      imageUrl,
      width: 50.w,
      height: 50.h,
      fit: BoxFit.cover,
      gaplessPlayback: true,
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
      errorBuilder: (_, __, ___) => Icon(
        Icons.image_outlined,
        size: 32.sp,
        color: AppColors.grey,
      ),
    );
  }
}
