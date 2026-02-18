import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_appbar.dart';
import '../productListing/product_listing.dart';
import '../profile/profile_controller.dart';
import '../wishlist/wishlist_screen.dart';
import 'category_controller.dart';
import 'category_shimmer.dart';
import 'sub_category_screen.dart';

class CategoryScreen extends StatefulWidget {
  final int initialIndex;
  const CategoryScreen({super.key, this.initialIndex = 0});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController controller = Get.find<CategoryController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
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
            image: AppAssets.search_icon,
            onTap: () {
              Get.to(() => const ProductListing());
            },
          ),
          Obx(() {
            final count = profileController.wishlistCount.value;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconBox(
                  image: AppAssets.like_icon,
                  onTap: () {
                    Get.to(() => const WishlistScreen());
                  },
                ),
                if (count > 0)
                  Positioned(
                    right: 6.w,
                    top: 5.h,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
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
          return const CategoryScreenShimmer();
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

        return Padding(
          padding: EdgeInsets.all(12.w),
          child: GridView.builder(
            itemCount: controller.categoryGroups.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 14.h,
              crossAxisSpacing: 14.w,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              if (index == controller.categoryGroups.length) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => const ProductListing());
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 80.h,
                        width: 80.h,
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
                        child: Icon(
                          Icons.grid_view_rounded,
                          size: 24.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      appText(
                        "See All",
                        textAlign: TextAlign.center,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                );
              }

              //  CATEGORY TILE
              final category = controller.categoryGroups[index];

              return GestureDetector(
                onTap: () {
                  category.subCategories.isEmpty
                      ? Get.to(
                          () => const ProductListing(),
                          arguments: {'categoryId': category.id},
                        )
                      : Get.to(() => SubCategoryScreen(category: category));
                },
                child: Column(
                  children: [
                    Container(
                      height: 80.h,
                      width: 80.h,
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
                        category.categoryImage?.url ?? '',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.image_outlined,
                          size: 40.sp,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    appText(
                      category.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
