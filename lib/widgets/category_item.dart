import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/models/category_model.dart';
import 'package:saoirse_app/screens/category/category_controller.dart';
import 'package:saoirse_app/widgets/app_text.dart';

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
          height: 110.h, // FIXED HEIGHT = no flicker
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 7.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.lightGrey : AppColors.white,
            border: Border(
              left: BorderSide(
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                width: 4.w,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 🔥 KEY
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CategoryImage(category: category),

              // Reduce spacing slightly
              SizedBox(height: 4.h),

              Flexible(
                // 🔥 KEY
                child: appText(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color:
                      isSelected ? AppColors.primaryColor : AppColors.textBlack,
                ),
              ),
            ],
          ),
        ),
      );
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
      errorBuilder: (_, __, ___) => Icon(
        Icons.image_outlined,
        size: 32.sp,
        color: AppColors.grey,
      ),
    );
  }
}
