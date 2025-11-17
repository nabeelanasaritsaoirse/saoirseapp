// app_colors.dart or app_gradients.dart
import 'package:flutter/material.dart';
import 'package:saoirse_app/constants/app_colors.dart';

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

  static final LinearGradient adverticementGradient = LinearGradient(
    colors: [AppColors.gradientPink, AppColors.gradientBlue],
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
  );

  static final LinearGradient succesGradient = LinearGradient(
    colors: [AppColors.gradientLightBlue, AppColors.gradientDarkBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
