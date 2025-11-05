import 'package:get/get.dart';

import '../constants/app_colors.dart';

appSnackbar({
  required String content,
  String title = 'Message',
  bool error = false,
}) {
  Get.snackbar(
    title,
    content,
    backgroundColor: error ? AppColors.red : AppColors.green,
    colorText: AppColors.white,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(seconds: 2),
  );
}
