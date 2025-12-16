import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/category_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text.dart';
import '../../widgets/category_item.dart';
import '../../widgets/custom_appbar.dart';
import '../productListing/product_listing.dart';
import '../profile/profile_controller.dart';
import '../wishlist/wishlist_screen.dart';
import 'category_controller.dart';

class CategoryScreen extends StatefulWidget {
  final int initialIndex;
  const CategoryScreen({super.key, this.initialIndex = 0});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController controller = Get.put(CategoryController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final controller = Get.find<CategoryController>();

      if (widget.initialIndex < controller.categoryGroups.length) {
        controller.selectedIndex.value = widget.initialIndex;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.paperColor,
        appBar: CustomAppBar(
          title: AppStrings.category_title,
          actions: [
            IconBox(
                image: AppAssets.search,
                padding: 9.w,
                onTap: () {
                  Get.to(() => const ProductListing());
                }),
            SizedBox(width: 8.w),
            Obx(() {
              final count = Get.find<ProfileController>().wishlistCount.value;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconBox(
                    image: AppAssets.wish,
                    padding: 8.w,
                    onTap: () {
                      Get.to(() => const WishlistScreen());
                    },
                  ),

                  // Show badge only if count > 0
                  if (count > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          count > 9 ? "9+" : count.toString(),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
            SizedBox(width: 12.w),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: appLoader());
          }
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: appText(controller.errorMessage.value),
            );
          }
          if (controller.categoryGroups.isEmpty) {
            return Center(
              child: appText(
                'No categories found',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            );
          }
//------------------ Left Sidebar Categories------------------//
          return Row(
            children: [
              Container(
                width: 80.h,
                color: AppColors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        controller: controller.scrollController.value,
                        physics: const ClampingScrollPhysics(), // IMPORTANT
                        padding: EdgeInsets.zero,
                        itemCount: controller.categoryGroups.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 0),
                        itemBuilder: (context, index) {
                          return CategoryItem(
                            index: index,
                            controller: controller,
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ProductListing());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.h,
                          horizontal: 7.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border(
                            top: BorderSide(
                              color: AppColors.lightGrey,
                              width: 1.w,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.grid_view_rounded,
                              size: 24.sp,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(height: 7.h),
                            appText(
                              'See All',
                              textAlign: TextAlign.center,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlack,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///------------------ Right Side Subcategory Grid View ------------------//
              Expanded(
                child: () {
                  final subCategories = controller.selectedSubCategories;

                  if (subCategories.isEmpty) {
                    return Center(
                      child: appText(
                        'No subcategories found',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: EdgeInsets.all(12.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: .72,
                    ),
                    itemCount: subCategories.length,
                    itemBuilder: (context, index) {
                      final subCategory = subCategories[index];

                      return SubCategoryCard(
                        subCategory: subCategory,
                        id: controller
                            .categoryGroups[controller.selectedIndex.value],
                      );
                    },
                  );
                }(),
              ),
            ],
          );
        }));
  }
}

//---------------------- SubCategoryCard Widget ---------------------//
class SubCategoryCard extends StatelessWidget {
  final SubCategory subCategory;
  final CategoryGroup id;

  const SubCategoryCard(
      {super.key, required this.subCategory, required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ProductListing(),
            arguments: {'categoryId': subCategory.id});
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Builder(
                builder: (_) {
                  final imageUrl = subCategory.image?.url;

                  if (imageUrl == null || imageUrl.isEmpty) {
                    // No image: only icon
                    return Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 40.sp,
                        color: AppColors.grey,
                      ),
                    );
                  }

                  // Image available: show network image, fallback to icon on errorreturn Image.
                  return Center(
                    child: Image.network(
                      imageUrl,
                      height: 75.h,
                      width: 80.w,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 50.sp,
                            color: AppColors.grey,
                          ),
                        );
                      },
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
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
