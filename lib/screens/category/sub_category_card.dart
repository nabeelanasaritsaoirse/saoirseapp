import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/models/category_model.dart';
import 'package:saoirse_app/screens/productListing/product_listing.dart';
import 'package:saoirse_app/widgets/app_text.dart';


class SubCategoryCard extends StatelessWidget {
  final SubCategory subCategory;
  final CategoryGroup id;

  const SubCategoryCard({
    super.key,
    required this.subCategory,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const ProductListing(),
          arguments: {'categoryId': subCategory.id},
        );
      },
      child: Column(
        children: [
          Container(
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
            padding: EdgeInsets.all(10.w),
            child: Center(
              child: Image.network(
                subCategory.image?.url ?? '',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_outlined,
                  size: 40.sp,
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          appText(
            subCategory.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
