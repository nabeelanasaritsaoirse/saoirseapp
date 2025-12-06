class ReferrerInfoModel {
  final String userId;
  final String name;
  final String email;
  final String profilePicture;
  final String referralCode;

  ReferrerInfoModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.referralCode,
  });

  factory ReferrerInfoModel.fromJson(Map<String, dynamic> json) {
    return ReferrerInfoModel(
      userId: json["userId"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      profilePicture: json["profilePicture"] ?? "",
      referralCode: json["referralCode"] ?? "",
    );
  }
}
