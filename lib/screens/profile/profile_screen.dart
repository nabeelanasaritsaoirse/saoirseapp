import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_text.dart';
import '../../widgets/profile_menu_card.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.paperColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: appText(
          "Profile",
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------- PROFILE BANNER -----------------------
            Stack(
              clipBehavior: Clip.none,
              children: [
                // BACKGROUND CONTAINER
                Container(
                  width: double.infinity,
                  height: 200.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.profile_bg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // PROFILE - DETAILS
                Positioned(
                  top: 20.h, // moves the circle down
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      // PROFILE WITH EDIT BUTTON
                      Stack(
                        children: [
                          Container(
                            width: 90.w,
                            height: 90.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                    AppAssets.facebook), // your profile image
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // SMALL EDIT ICON
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 28.w,
                              height: 28.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: AppColors.white,
                                size: 14.sp,
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 12.h),

                      appText('Albert Dan',
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBlack,
                          fontSize: 18.sp),
                      appText('albert.dan@gmail.com',
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBlack,
                          fontSize: 14.sp)
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // -------------------- MY ORDERS TITLE ---------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: appText(
                "My Orders",
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),

            SizedBox(height: 10.h),

            // -------------------- MY ORDERS GRID -----------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.myOrders.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: .90,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                ),
                itemBuilder: (_, index) {
                  return ProfileMenuCard(
                    icon: controller.myOrders[index]["icon"]!,
                    title: controller.myOrders[index]["title"]!,
                  );
                },
              ),
            ),

            SizedBox(height: 20.h),

            // -------------------- SETTINGS TITLE ---------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: appText(
                "Settings",
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),

            SizedBox(height: 10.h),

            // -------------------- SETTINGS GRID -----------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.settings.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: .90,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                ),
                itemBuilder: (_, index) {
                  return ProfileMenuCard(
                    icon: controller.settings[index]["icon"]!,
                    title: controller.settings[index]["title"]!,
                  );
                },
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
