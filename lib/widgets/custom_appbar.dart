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
  final bool showGreeting; // ✅ NEW
  final String? userName; // ✅ NEW
  final List<Widget>? actions;
  final double height;

  const CustomAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.showBack = false,
    this.showGreeting = false,
    this.userName,
    this.actions,
    this.height = 48,
  });

  Widget _buildLogo() {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
      ),
      child: Image.asset(
        AppAssets.app_logo,
        height: 26.h,
        width: 26.w,
      ),
    );
  }

  String formatUserName(String? name, {int maxLength = 12}) {
    if (name == null || name.trim().isEmpty) return "User";

    final trimmed = name.trim();
    if (trimmed.length <= maxLength) return trimmed;

    return "${trimmed.substring(0, maxLength)}…";
  }

  Widget _buildGreeting() {
    final displayName = formatUserName(userName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        appText(
          "Hello $displayName",
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        appText(
          "Welcome to EPI",
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          // ignore: deprecated_member_use
          color: AppColors.white.withOpacity(0.9),
        ),
      ],
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
        leadingWidth: showLogo ? 55.w : 45.w,
        leading: showBack
            ? _buildBackButton()
            : showLogo
                ? _buildLogo()
                : null,
        titleSpacing: showLogo ? 6.w : 20.w,
        title: showGreeting
            ? _buildGreeting()
            : title != null
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

// class IconBoxs extends StatelessWidget {
//   final String image;
//   final VoidCallback onTap;

//   const IconBoxs({
//     super.key,
//     required this.image,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8.r),
//       child: SizedBox(
//         width: 36.w, // 🔒 fixed tap area
//         height: 36.h,
//         child: Center(
//           child: SvgPicture.asset(
//             image,
//             width: 22.w, // ✅ REAL ICON SIZE
//             height: 22.w,
//             fit: BoxFit.contain,
//             colorFilter: const ColorFilter.mode(
//               AppColors.white,
//               BlendMode.srcIn,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
