import 'package:get/get.dart';

import '../screens/login/login_controller.dart';
import '../screens/refferal/referral_controller.dart';

class Allcontroller implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ReferralController>(
      () => ReferralController(),
    );
  }
}
