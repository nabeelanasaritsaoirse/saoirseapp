import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:saoirse_app/screens/category/sub_category_card.dart';

import '../../constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';


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
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: .72,
                ),
                itemBuilder: (context, index) {
                  final subCategory = category.subCategories[index];

                  return SubCategoryCard(
                    subCategory: subCategory,
                    id: category,
                  );
                },
              ),
            ),
    );
  }
}
