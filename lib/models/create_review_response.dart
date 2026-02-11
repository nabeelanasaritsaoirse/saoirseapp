class CreateReviewResponse {
  final bool success;
  final String message;
  final CreatedReview review;
  final ProductReviewStats productStats;
  final AutoModerationInfo? autoModeration;

  CreateReviewResponse({
    required this.success,
    required this.message,
    required this.review,
    required this.productStats,
    this.autoModeration,
  });

  factory CreateReviewResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return CreateReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      review: CreatedReview.fromJson(data['review'] ?? {}),
      productStats:
          ProductReviewStats.fromJson(data['productStats'] ?? {}),
      autoModeration: data['autoModeration'] != null
          ? AutoModerationInfo.fromJson(data['autoModeration'])
          : null,
    );
  }
}

// =======================================================
// REVIEW DATA
// =======================================================

class CreatedReview {
  final String id;
  final int rating;
  final String title;
  final String comment;
  final String userName;
  final bool verifiedPurchase;
  final String status;
  final DateTime createdAt;

  CreatedReview({
    required this.id,
    required this.rating,
    required this.title,
    required this.comment,
    required this.userName,
    required this.verifiedPurchase,
    required this.status,
    required this.createdAt,
  });

  factory CreatedReview.fromJson(Map<String, dynamic> json) {
    return CreatedReview(
      id: json['_id'] ?? '',
      rating: json['rating'] ?? 0,
      title: json['title'] ?? '',
      comment: json['comment'] ?? '',
      userName: json['userName'] ?? '',
      verifiedPurchase: json['verifiedPurchase'] ?? false,
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ??
          DateTime.now(),
    );
  }
}

// =======================================================
// PRODUCT STATS
// =======================================================

class ProductReviewStats {
  final double averageRating;
  final int totalReviews;

  ProductReviewStats({
    required this.averageRating,
    required this.totalReviews,
  });

  factory ProductReviewStats.fromJson(Map<String, dynamic> json) {
    return ProductReviewStats(
      averageRating:
          (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }
}

// =======================================================
// AUTO MODERATION (OPTIONAL)
// =======================================================

class AutoModerationInfo {
  final bool isFlagged;
  final String message;

  AutoModerationInfo({
    required this.isFlagged,
    required this.message,
  });

  factory AutoModerationInfo.fromJson(Map<String, dynamic> json) {
    return AutoModerationInfo(
      isFlagged: json['isFlagged'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
