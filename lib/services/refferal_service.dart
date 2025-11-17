import 'dart:async';
import 'package:flutter/material.dart';
import 'package:saoirse_app/constants/app_constant.dart';
import 'package:saoirse_app/constants/app_urls.dart';
import 'package:saoirse_app/main.dart';
import 'package:saoirse_app/models/dashboard_model.dart';
import 'package:saoirse_app/models/refferal_model.dart';
import 'package:saoirse_app/services/api_service.dart';

class ReferralService {

  //  To fetch referral code
  
  Future<ReferralResponse?> fetchReferralCode() async {
    final userId = await storage.read(AppConst.USER_ID);

    if (userId == null || userId.isEmpty) {
      throw Exception("User ID not found. Please log in again.");
    }

    final url = AppURLs.getRefferal_API;

    return APIService.postRequest<ReferralResponse>(
      url: url,
      body: {
        'userId': userId,
      },
      onSuccess: (json) {
        final referral = ReferralResponse.fromJson(json);

        if (!referral.success) {
          throw Exception(referral.message);
        }

        debugPrint("Referral code fetched: ${referral.referralCode}");
        return referral;
      },
    );
  }

  //  To fetch referral User List & Data

   Future<DashboardModel?> fetchReferralDashboard() async {
  final userId = await storage.read(AppConst.USER_ID);

  if (userId == null || userId.isEmpty) {
    throw Exception("User ID not found. Please log in again.");
  }

  final url = "${AppURLs.getDashboard_API}$userId";

  return APIService.getRequest<DashboardModel>(
    url: url,
    onSuccess: (json) {
      final dashboard = DashboardModel.fromJson(json);

      
      if (!dashboard.success) {
        throw Exception("Failed to fetch dashboard data.");
      }

      return dashboard;
    },
  );
}

}
