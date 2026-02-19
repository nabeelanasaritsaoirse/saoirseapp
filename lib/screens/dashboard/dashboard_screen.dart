// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final DashboardController controller = Get.find<DashboardController>();
  final CartController cartController = Get.find<CartController>();

  final List<Widget> pages = [
    const HomeScreen(),
    CategoryScreen(),
    ReferralScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // we control back manually
      // onPopInvoked: (didPop) {
      //   final currentIndex = controller.selectedIndex.value;

      //   if (currentIndex != 0) {
      //     controller.changeTab(0);
      //   } else {
      //     SystemNavigator.pop();
      //   }
      // },
     onPopInvoked: (didPop) async {
    final shouldExit = controller.handleBackPress();

    if (shouldExit) {
      SystemNavigator.pop();
    }
  },
      
      child: Scaffold(
        body: Obx(() => pages[controller.selectedIndex.value]),
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
                      index: 0,
                      icon: Iconsax.home,
                      activeIcon: Iconsax.home,
                      label: 'Home',
                    ),
                    _navItem(
                      index: 1,
                      icon: Iconsax.category,
                      activeIcon: Iconsax.category5,
                      label: 'Category',
                    ),
                    _navItem(
                      index: 2,
                      icon: Iconsax.gift,
                      activeIcon: Iconsax.gift,
                      label: 'Referral',
                    ),
                    _navItem(
                      index: 3,
                      icon: Iconsax.shopping_cart,
                      activeIcon: Iconsax.shopping_cart,
                      label: 'Cart',
                      badgeCount:
                          cartController.cartCount.value, //directy passing
                    ),
                    _navItem(
                      index: 4,
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
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int? badgeCount,
  }) {
    final bool isReferral = index == 2;
    return BottomNavigationBarItem(
      label: label,

      // INACTIVE ICON
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          isReferral
              ? Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                )
              : Icon(
                  icon,
                  size: 22.sp,
                  color: AppColors.grey,
                ),
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
          isReferral
              ? Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    activeIcon,
                    size: 18.sp,
                    color: AppColors.white,
                  ),
                )
              // OTHERS → NO CIRCLE
              : Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    activeIcon,
                    size: 22.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
          if (badgeCount != null && badgeCount > 0)
            Positioned(
              right: 5,
              top: 5,
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
