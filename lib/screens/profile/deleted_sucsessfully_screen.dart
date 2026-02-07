import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saoirse_app/constants/app_colors.dart';
import 'package:saoirse_app/widgets/app_text.dart';

class DeletedSucsessfullyScreen extends StatelessWidget {
  const DeletedSucsessfullyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 90.sp, color: AppColors.green),
          SizedBox(height: 10.h),
          appText("Your request has been submitted", fontSize: 20.sp),
        ],
      ),
    );
  }
}