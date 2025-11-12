// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/app_colors.dart';
import '../category/category_screen.dart';
import '../home/home_screen.dart';
import '../refferal/refferal_screen.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final DashboardController controller = Get.put(DashboardController());

  final List<Widget> pages = [
    const HomeScreen(),
    CategoryScreen(),
    ReferralScreen(),
    CategoryScreen(),
    CategoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTab,
            elevation: 0,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.grey,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            items: [
              _navItem(
                icon: Iconsax.home,
                activeIcon: Iconsax.home,
                label: 'Home',
              ),
              _navItem(
                icon: Iconsax.category,
                activeIcon: Iconsax.category5,
                label: 'Category',
              ),
              _navItem(
                icon: Iconsax.gift,
                activeIcon: Iconsax.gift,
                label: 'Referral',
              ),
              _navItem(
                icon: Iconsax.shopping_cart,
                activeIcon: Iconsax.shopping_cart,
                label: 'Cart',
              ),
              _navItem(
                icon: Iconsax.user,
                activeIcon: Iconsax.user,
                label: 'You',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Custom BottomNav Item Builder
  BottomNavigationBarItem _navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 26.sp),
      activeIcon: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(activeIcon, color: AppColors.white, size: 20.sp),
      ),
      label: label,
    );
  }
}
