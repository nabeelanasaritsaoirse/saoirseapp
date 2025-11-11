import 'package:fluttertoast/fluttertoast.dart';
import '../constants/app_colors.dart';

appToast({
  required String message,
  bool error = false,
  ToastGravity gravity = ToastGravity.BOTTOM,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    backgroundColor: error ? AppColors.red : AppColors.green,
    textColor: AppColors.white,
    fontSize: 14.0,
  );
}
