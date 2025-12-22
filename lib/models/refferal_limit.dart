import 'dart:convert';

ReferralStatsResponse referralStatsResponseFromJson(String str) =>
    ReferralStatsResponse.fromJson(json.decode(str));

class ReferralStatsResponse {
  final bool success;
  final ReferralStatsData data;
  final String message;

  ReferralStatsResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ReferralStatsResponse.fromJson(Map<String, dynamic> json) {
    return ReferralStatsResponse(
      success: json['success'],
      data: ReferralStatsData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class ReferralStatsData {
  final String referralCode;
  final String referralLink;
  final int totalReferrals;
  final int referralLimit;
  final int remainingReferrals;
  final bool referralLimitReached;

  ReferralStatsData({
    required this.referralCode,
    required this.referralLink,
    required this.totalReferrals,
    required this.referralLimit,
    required this.remainingReferrals,
    required this.referralLimitReached,
  });

  factory ReferralStatsData.fromJson(Map<String, dynamic> json) {
    return ReferralStatsData(
      referralCode: json['referralCode'],
      referralLink: json['referralLink'],
      totalReferrals: json['totalReferrals'],
      referralLimit: json['referralLimit'],
      remainingReferrals: json['remainingReferrals'],
      referralLimitReached: json['referralLimitReached'],
    );
  }
}
