import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import 'app_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final bool showBack;
  final List<Widget>? actions;
  final double height;

  const CustomAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.showBack = false,
    this.actions,
    this.height = 48,
  });

  Widget _buildLogo() {
    return Padding(
      padding: EdgeInsets.only(
        left: 12.w,
      ),
      child: Image.asset(
        AppAssets.app_logo,
        height: 26.h,
        width: 26.w,
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () => Get.back(),
      icon: Icon(
        Icons.arrow_back,
        color: AppColors.white,
        size: 25.sp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height.h),
      child: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leadingWidth: showLogo ? 56.w : 45.w,
        leading: showBack
            ? _buildBackButton()
            : showLogo
                ? _buildLogo()
                : null,
        titleSpacing: 20,
        title: title != null
            ? appText(
                title!,
                fontSize: 19.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              )
            : null,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height.h);
}

class IconBox extends StatelessWidget {
  final String image;
  final double padding;
  final VoidCallback onTap;

  const IconBox({
    super.key,
    required this.image,
    required this.padding,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        width: 33.w,
        height: 29.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Image.asset(image),
        ),
      ),
    );
  }
}
