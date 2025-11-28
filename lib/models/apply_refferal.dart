class ApplyReferralResponse {
  final bool success;
  final String message;
  final String? userId;
  final String? referrerId;
  final String? code;

  ApplyReferralResponse({
    required this.success,
    required this.message,
    this.userId,
    this.referrerId,
    this.code,
  });

  factory ApplyReferralResponse.fromJson(Map<String, dynamic> json) {
    return ApplyReferralResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      userId: json["data"]?["userId"],
      referrerId: json["data"]?["referrerId"],
      code: json["code"], // error code if any
    );
  }
}
