import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

Widget appLoader({double? height, double? width}) {
  return WillPopScope(
    onWillPop: () async => false,
    child: InkWell(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          alignment: Alignment.center,
          child: SizedBox(
            height: height ?? 60.h,
            width: width ?? 60.w,
            child: const CupertinoActivityIndicator(color: AppColors.grey),
          ),
        ),
      ),
    ),
  );
}
