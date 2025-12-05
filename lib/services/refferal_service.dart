// ignore_for_file: avoid_print

import 'dart:async';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/apply_refferal.dart';
import '../models/friend_details_response.dart';
import '../models/product_detiails_response.dart';
import '../models/referral_response_model.dart';
import '../models/refferal_info_model.dart';
import '../services/api_service.dart';
import '../widgets/app_toast.dart';

class ReferralService {
  //  To fetch referral User List & Data
  final token = storage.read(AppConst.ACCESS_TOKEN);

  Future<ReferralResponse?> fetchReferralResponseFromServer() async {
    final userId = await storage.read(AppConst.USER_ID);

    if (userId == null || userId.isEmpty) {
      throw Exception("User ID not found. Please log in again.");
    }

    final url = "${AppURLs.FETCH_REFERRAL}$userId";

    return APIService.getRequest<ReferralResponse>(
      url: url,
      onSuccess: (json) {
        final referralResponse = ReferralResponse.fromJson(json);

        if (!referralResponse.success) {
          throw Exception(referralResponse.message);
        }

        return referralResponse;
      },
    );
  }

  Future<ProductDetailsResponse?> fetchProductDetails(
    String friendId,
    String productId,
  ) async {
    final url = "${AppURLs.PRODUCT_DETAILS}$friendId/$productId";

    return APIService.getRequest<ProductDetailsResponse>(
      url: url,
      onSuccess: (json) {
        return ProductDetailsResponse.fromJson(json);
      },
    );
  }

  Future<FriendDetailsResponse?> fetchFriendDetails(String friendId) async {
    final url = "${AppURLs.FRIEND_DETAILS}$friendId";

    return APIService.getRequest<FriendDetailsResponse>(
      url: url,
      onSuccess: (json) {
        final data = FriendDetailsResponse.fromJson(json);

        if (!data.success) {
          throw Exception("Failed to fetch friend details");
        }

        return data;
      },
    );
  }

  // To apply referral code
  Future<ApplyReferralResponse?> applyReferralCode(String referralCode) async {
    try {
      final url = AppURLs.APPLY_REFERRAL;

      print("APPLY REFERRAL");
      print("URL: $url");
      print("Token: $token");
      print("Referral Code: $referralCode");

      final response = await APIService.postRequest(
        url: url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: {
          "referralCode": referralCode.trim(),
        },
        onSuccess: (json) => json,
      );

      if (response == null) return null;

      return ApplyReferralResponse.fromJson(response);
    } catch (e) {
      print("Referral Error: $e");
      return null;
    }
  }

  Future<ReferrerInfoModel?> getReferrerInfo() async {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

    final response = await APIService.getRequest(
      url: AppURLs.REFERRAL_INFO,
      headers: {
        "Authorization": "Bearer $token",
      },
      onSuccess: (json) => json,
    );

    if (response == null) return null;

    if (response["success"] == true && response["referredBy"] != null) {
      return ReferrerInfoModel.fromJson(response["referredBy"]);
    } else {
      appToast(error: true, content: "Referral data not found");
      return null;
    }
  }
}
