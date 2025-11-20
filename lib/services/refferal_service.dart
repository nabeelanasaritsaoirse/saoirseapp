import 'dart:async';
import 'package:flutter/material.dart';

import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/friend_details_response.dart';
import '../models/product_detiails_response.dart';
import '../models/referral_response_model.dart';
import '../models/refferal_model.dart';
import '../services/api_service.dart';

class ReferralService {
  //  To fetch referral code

  Future<ReferralResponses?> fetchReferralCode() async {
    final userId = await storage.read(AppConst.USER_ID);

    if (userId == null || userId.isEmpty) {
      throw Exception("User ID not found. Please log in again.");
    }

    final url = AppURLs.getRefferal_API;

    return APIService.postRequest<ReferralResponses>(
      url: url,
      body: {
        'userId': userId,
      },
      onSuccess: (json) {
        final referral = ReferralResponses.fromJson(json);

        if (!referral.success) {
          throw Exception(referral.message);
        }

        debugPrint("Referral code fetched: ${referral.referralCode}");
        return referral;
      },
    );
  }

  //  To fetch referral User List & Data

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
}
