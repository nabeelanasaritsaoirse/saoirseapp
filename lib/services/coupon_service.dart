
import 'dart:developer';
import 'package:saoirse_app/constants/app_urls.dart';

import '../services/api_service.dart';
import '../models/coupon_model.dart';

class CouponService {
  
  static Future<List<Coupon>?> fetchCoupons() async {
    final url = AppURLs.GET_ALL_COUPONS;

    try {
      final result = await APIService.getRequest<Map<String, dynamic>>(
        url: url,
        onSuccess: (json) {
          final list = (json["coupons"] as List<dynamic>?) ?? [];
          return {
            "coupons": list,
          };
        },
      );

      if (result == null) return [];

      final rawList = (result["coupons"] as List<dynamic>?) ?? [];
      final coupons = rawList.map((e) {
        return Coupon.fromJson(e as Map<String, dynamic>);
      }).toList();

      return coupons;
    } catch (e, st) {
      log("CouponService.fetchCoupons error: $e\n$st");
      return null;
    }
  }
}
