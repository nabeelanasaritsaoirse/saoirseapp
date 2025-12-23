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

  final DashboardController controller = Get.find();
  final CartController cartController = Get.find();

  final List<Widget> pages = const [
    HomeScreen(),
    CategoryScreen(),
    ReferralScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return Container(
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
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changeTab,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: AppColors.primaryColor,
              unselectedItemColor: AppColors.grey,
              showUnselectedLabels: true,
              items: [
                _navItem(Iconsax.home, 'Home'),
                _navItem(Iconsax.category, 'Category'),
                _navItem(Iconsax.gift, 'Referral'),
                _navItem(
                  Iconsax.shopping_cart,
                  'Cart',
                  badgeCount: cartController.cartCount.value,
                ),
                _navItem(Iconsax.user, 'You'),
              ],
            ),
          ),
        );
      }),
    );
  }

  BottomNavigationBarItem _navItem(
    IconData icon,
    String label, {
    int? badgeCount,
  }) {
    return BottomNavigationBarItem(
      label: label,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: 22),
          if (badgeCount != null && badgeCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: Text(
                  badgeCount > 9 ? '9+' : badgeCount.toString(),
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
