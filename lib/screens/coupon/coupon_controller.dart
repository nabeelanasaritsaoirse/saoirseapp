import 'package:get/get.dart';

import '../../models/coupon_model.dart';
import '../../services/coupon_service.dart';

class CouponController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

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
      errorMessage.value = '';

      final result = await CouponService.fetchCoupons();

      if (result.isEmpty) {
        errorMessage.value = "No coupons available";
        coupons.clear();
        return;
      }

      /// Only active coupons
      coupons.assignAll(result.where((c) => c.isActive));
    } catch (e) {
      errorMessage.value = "Failed to load coupons";
    } finally {
      isLoading.value = false;
    }
  }
}
