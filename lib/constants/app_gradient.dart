// app_colors.dart or app_gradients.dart
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppGradients {
  static const LinearGradient blueVertical = LinearGradient(
    colors: [Color(0xFF6BA8E5), Color(0xFF1E3C72)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient topCarosalGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [AppColors.lightBlack, AppColors.transparent],
  );

  static final LinearGradient succesGradient = LinearGradient(
    colors: [AppColors.gradientLightBlue, AppColors.gradientDarkBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF5B5FE9),
      Color(0xFF0A0E8C),
    ],
  );

  static final LinearGradient progressIndicatoryGradient = LinearGradient(
    colors: [AppColors.mediumBlue, AppColors.primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient progressbarGradient = LinearGradient(
    colors: [
      Colors.white,
      Colors.lightBlue.shade200,
    ],
  );

  static final LinearGradient paynowGradient = LinearGradient(
    colors: [
      Color(0xFF5A5A5A),
      Color(0xFF000000),
    ],
  );
}
