// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/app_colors.dart';
import '../cart/cart_controller.dart';
import '../cart/cart_screen.dart';
import '../category/category_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../refferal/referral_screen.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final DashboardController controller = Get.put(DashboardController());
  final CartController cartController = Get.put(CartController());

  final List<Widget> pages = [
    const HomeScreen(),
    CategoryScreen(),
    ReferralScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedIndex.value != 0) {
          controller.changeTab(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Obx(() => pages[controller.selectedIndex.value]),
        ),
        bottomNavigationBar: Obx(
          () => Container(
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
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(top: 4.h, bottom: 2.h),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  currentIndex: controller.selectedIndex.value,
                  onTap: controller.changeTab,
                  elevation: 0,
                  selectedItemColor: AppColors.primaryColor,
                  unselectedItemColor: AppColors.grey,
                  showUnselectedLabels: true,
                  selectedLabelStyle: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 11.sp,
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
                      badgeCount:
                          cartController.cartCount.value, //directy passing
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
          ),
        ),
      ),
    );
  }

  /// Custom BottomNav Item Builder with Badge Support
  BottomNavigationBarItem _navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int? badgeCount,
  }) {
    return BottomNavigationBarItem(
      label: label,

      // INACTIVE ICON
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: 22.sp),
          if (badgeCount != null && badgeCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeCount > 9 ? "9+" : badgeCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),

      // ACTIVE ICON (Highlighted)
      activeIcon: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(activeIcon, color: AppColors.white, size: 19.sp),
          ),
          if (badgeCount != null && badgeCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeCount > 9 ? "9+" : badgeCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
