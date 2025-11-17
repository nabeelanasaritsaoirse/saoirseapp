class ReferralModel {
  final String code;
  final List<ReferralUser> referrals;

  ReferralModel({
    required this.code,
    required this.referrals,
  });
}

class ReferralUser {
  final int no;
  final String name;
  final int purchaseItems;
  final int commission;

  ReferralUser({
    required this.no,
    required this.name,
    required this.purchaseItems,
    required this.commission,
  });
}

class ReferralResponses {
  final bool success;
  final String referralCode;
  final bool isExistingCode;
  final String message;

  ReferralResponses({
    required this.success,
    required this.referralCode,
    required this.isExistingCode,
    required this.message,
  });

  factory ReferralResponses.fromJson(Map<String, dynamic> json) {
    return ReferralResponses(
      success: json['success'] ?? false,
      referralCode: json['referralCode'] ?? '',
      isExistingCode: json['isExistingCode'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
