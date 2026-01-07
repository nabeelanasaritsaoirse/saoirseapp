import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import '../productListing/product_listing.dart';

class SubCategoryScreen extends StatelessWidget {
  final CategoryGroup category;

  const SubCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: CustomAppBar(
        title: category.name,
        showBack: true,
      ),
      body: category.subCategories.isEmpty
          ? Center(
              child: appText(
                'No subcategories found',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(12.w),
              child: GridView.builder(
                itemCount: category.subCategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.76,
              
                ),
                itemBuilder: (context, index) {
                  final subCategory = category.subCategories[index];

                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const ProductListing(),
                        arguments: {'categoryId': subCategory.id},
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 80.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 6.r,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(12.w),
                          child: Image.network(
                            subCategory.image?.url ?? '',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.image_outlined,
                              size: 36.sp,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          height: 32.h,
                          child: appText(
                            subCategory.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
