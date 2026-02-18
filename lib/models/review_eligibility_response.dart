class ReviewEligibilityResponse {
  final bool success;
  final String message;
  final ReviewEligibilityData data;

  ReviewEligibilityResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReviewEligibilityResponse.fromJson(Map<String, dynamic> json) {
    return ReviewEligibilityResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ReviewEligibilityData.fromJson(json['data'] ?? {}),
    );
  }
}

class ReviewEligibilityData {
  final bool canReview;
  final String? reason;
  final bool hasDeliveredOrder;
  final String? existingReviewId;

  ReviewEligibilityData({
    required this.canReview,
    this.reason,
    required this.hasDeliveredOrder,
    this.existingReviewId,
  });

  factory ReviewEligibilityData.fromJson(Map<String, dynamic> json) {
    return ReviewEligibilityData(
      canReview: json['canReview'] ?? false,
      reason: json['reason'],
      hasDeliveredOrder: json['hasDeliveredOrder'] ?? false,
      existingReviewId: json['existingReviewId'],
    );
  }
}
