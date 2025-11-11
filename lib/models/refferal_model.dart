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