import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:saoirse_app/constants/app_colors.dart';

void appToast({
  required String content,
  String title = 'Message',
  bool error = false,
}) {
  final status = error ? "❌ ERROR" : "✅ SUCCESS";

  log("$status | $title → $content");
}

void appToaster({
  required String content,
  bool error = false,
}) {
  Fluttertoast.showToast(
    msg: content,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: error ? AppColors.red : AppColors.green,
    textColor: AppColors.white,
    fontSize: 14.0,
  );
}
