import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF000E63), // Deep blue background
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left section: Logo + Texts
            Row(
              children: [
                Image.asset('assets/images/app_logo.png'),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hello Arun",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Welcome to EPI",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Right section: Icons
            Row(
              children: [
                _iconBox(Icons.notifications_none_rounded),
                SizedBox(width: 8.w),
                _iconBox(Icons.search),
                SizedBox(width: 8.w),
                _iconBox(Icons.account_balance_wallet_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Custom white box icon
  Widget _iconBox(IconData icon) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Icon(icon, color: Colors.black87, size: 22.sp),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}
