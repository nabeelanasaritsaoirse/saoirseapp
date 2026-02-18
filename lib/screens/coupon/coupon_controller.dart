import 'package:get/get.dart';

import '../../models/coupon_model.dart';
import '../../services/coupon_service.dart';

class CouponController extends GetxController {
  RxBool isLoading = false.obs;

  /// All coupons
  RxList<Coupon> coupons = <Coupon>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCoupons();
  }

  Future<void> loadCoupons() async {
    try {
      isLoading.value = true;

      final result = await CouponService.fetchCoupons();

      if (result.isEmpty) {
        coupons.clear();
        return;
      }

      /// Only active coupons
      coupons.assignAll(result.where((c) => c.isActive));
    } finally {
      isLoading.value = false;
    }
  }
}
