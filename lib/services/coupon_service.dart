import 'package:flutter/material.dart';

import '../constants/app_urls.dart';
import '../models/coupon_validation_model.dart';
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
  static Future<CouponValidationResponse> validateCoupon(
    Map<String, dynamic> body,
  ) async {
    final url = AppURLs.POST_RQ_COUPONS_VALIDATION;

    try {
      final result = await APIService.postRequest<CouponValidationResponse>(
        url: url,
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
        onSuccess: (json) {
          debugPrint("🟡 [COUPON API] Raw response: $json");

          // ❌ Coupon invalid / expired (BACKEND MESSAGE)
          if (json["success"] == false) {
            throw json["message"] ?? "Coupon is not valid anymore";
          }

          final payload = json["data"];
          if (payload == null) {
            throw "Invalid coupon response from server";
          }

          return CouponValidationResponse.fromJson(
            payload as Map<String, dynamic>,
          );
        },
      );

      // ⚠️ IMPORTANT CHANGE HERE
      if (result == null) {
        throw "Coupon is not valid anymore";
      }

      return result;
    } catch (e) {
      debugPrint("❌ [COUPON API] Error: $e");
      rethrow; // 🔥 message goes to UI
    }
  }
}
