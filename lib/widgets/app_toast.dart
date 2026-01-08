import 'package:fluttertoast/fluttertoast.dart';

import '../constants/app_colors.dart';

void appToast({
  required String content,
  String title = 'Message',
  bool error = false,
}) {}

void appToaster({
  required String content,
  bool error = false,
}) {
  Fluttertoast.showToast(
    msg: content,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: error ? AppColors.black : AppColors.green,
    textColor: AppColors.white,
    fontSize: 14.0,
  );
}
