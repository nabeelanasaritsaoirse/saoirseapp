import 'package:flutter/widgets.dart';
import 'package:saoirse_app/constants/app_urls.dart';
import 'package:saoirse_app/models/coupon_validation_model.dart';
import '../services/api_service.dart';
import '../models/coupon_model.dart';

class CouponService {

  //---------------Get All Coupon------------------------//
  static Future<List<Coupon>> fetchCoupons() async {
    final url = AppURLs.GET_ALL_COUPONS;
    final response = await APIService.getRequest<List<Coupon>>(
      url: url,
      onSuccess: (json) {
        final list = json["coupons"] as List<dynamic>?;

        if (list == null) return [];

        return list.map((e) => Coupon.fromJson(e)).toList();
      },
    );

    return response ?? [];
  }


  //-------------send the request to the api so it will send the coupon validation response---------//
static Future<CouponValidationResponse?> validateCoupon(Map<String, dynamic> body) async {
  debugPrint("Validate Coupon Body => $body");
  final url = AppURLs.POST_RQ_COUPONS_VALIDATION;

  return await APIService.postRequest<CouponValidationResponse?>(
    url: url,
    body: body,
    headers: {
      "Content-Type": "application/json",
    },
    onSuccess: (json) {
      try {
        final payload = json.containsKey("data") ? json["data"] : json;
        if (payload == null) return null;
        return CouponValidationResponse.fromJson(payload as Map<String, dynamic>);
      } catch (e, st) {
        debugPrint("Coupon parse error: $e\n$st");
        return null;
      }
    },
  );
}

}
