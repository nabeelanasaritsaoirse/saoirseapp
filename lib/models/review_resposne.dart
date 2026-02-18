// review_response.dart

class ReviewResponse {
  final bool success;
  final String message;
  final ReviewData data;
  final Meta meta;

  ReviewResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      success: json['success'],
      message: json['message'],
      data: ReviewData.fromJson(json['data']),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

/* -------------------- DATA -------------------- */

class ReviewData {
  final List<Review> reviews;
  final RatingStats ratingStats;
  final Pagination pagination;

  ReviewData({
    required this.reviews,
    required this.ratingStats,
    required this.pagination,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      reviews: (json['reviews'] as List)
          .map((e) => Review.fromJson(e))
          .toList(),
      ratingStats: RatingStats.fromJson(json['ratingStats']),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

/* -------------------- REVIEW -------------------- */

class Review {
  final String id;
  final String user;
  final String product;
  final String order;
  final int rating;
  final String title;
  final String comment;
  final List<ReviewImage> images;
  final String userName;
  final String userProfilePicture;
  final String productName;
  final String productId;
  final bool verifiedPurchase;
  final DateTime purchaseDate;
  final int orderValue;
  final String status;
  final int editCount;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  final DetailedRatings detailedRatings;
  final VariantInfo variantInfo;
  final Helpfulness helpfulness;
  final SellerResponse sellerResponse;
  final QualityMetrics qualityMetrics;

  Review({
    required this.id,
    required this.user,
    required this.product,
    required this.order,
    required this.rating,
    required this.title,
    required this.comment,
    required this.images,
    required this.userName,
    required this.userProfilePicture,
    required this.productName,
    required this.productId,
    required this.verifiedPurchase,
    required this.purchaseDate,
    required this.orderValue,
    required this.status,
    required this.editCount,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.detailedRatings,
    required this.variantInfo,
    required this.helpfulness,
    required this.sellerResponse,
    required this.qualityMetrics,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      user: json['user'],
      product: json['product'],
      order: json['order'],
      rating: json['rating'],
      title: json['title'],
      comment: json['comment'],
      images: (json['images'] as List)
          .map((e) => ReviewImage.fromJson(e))
          .toList(),
      userName: json['userName'],
      userProfilePicture: json['userProfilePicture'] ?? '',
      productName: json['productName'],
      productId: json['productId'],
      verifiedPurchase: json['verifiedPurchase'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      orderValue: json['orderValue'],
      status: json['status'],
      editCount: json['editCount'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      detailedRatings: DetailedRatings.fromJson(json['detailedRatings']),
      variantInfo: VariantInfo.fromJson(json['variantInfo']),
      helpfulness: Helpfulness.fromJson(json['helpfulness']),
      sellerResponse: SellerResponse.fromJson(json['sellerResponse']),
      qualityMetrics: QualityMetrics.fromJson(json['qualityMetrics']),
    );
  }
}

/* -------------------- NESTED MODELS -------------------- */

class DetailedRatings {
  final int quality;
  final int valueForMoney;
  final int delivery;
  final int accuracy;

  DetailedRatings({
    required this.quality,
    required this.valueForMoney,
    required this.delivery,
    required this.accuracy,
  });

  factory DetailedRatings.fromJson(Map<String, dynamic> json) {
    return DetailedRatings(
      quality: json['quality'],
      valueForMoney: json['valueForMoney'],
      delivery: json['delivery'],
      accuracy: json['accuracy'],
    );
  }
}

class VariantInfo {
  final String? variantId;
  final String? variantName;
  final String? color;
  final String? size;
  final String? sku;

  VariantInfo({
    this.variantId,
    this.variantName,
    this.color,
    this.size,
    this.sku,
  });

  factory VariantInfo.fromJson(Map<String, dynamic> json) {
    return VariantInfo(
      variantId: json['variantId'],
      variantName: json['variantName'],
      color: json['color'],
      size: json['size'],
      sku: json['sku'],
    );
  }
}

class Helpfulness {
  final int upvotes;
  final int downvotes;
  final int score;
  final List<String> voters;

  Helpfulness({
    required this.upvotes,
    required this.downvotes,
    required this.score,
    required this.voters,
  });

  factory Helpfulness.fromJson(Map<String, dynamic> json) {
    return Helpfulness(
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
      score: json['score'],
      voters: List<String>.from(json['voters']),
    );
  }
}

class SellerResponse {
  final String? message;
  final String? respondedBy;
  final String? respondedByEmail;
  final DateTime? respondedAt;
  final bool isVisible;

  SellerResponse({
    this.message,
    this.respondedBy,
    this.respondedByEmail,
    this.respondedAt,
    required this.isVisible,
  });

  factory SellerResponse.fromJson(Map<String, dynamic> json) {
    return SellerResponse(
      message: json['message'],
      respondedBy: json['respondedBy'],
      respondedByEmail: json['respondedByEmail'],
      respondedAt:
          json['respondedAt'] != null ? DateTime.parse(json['respondedAt']) : null,
      isVisible: json['isVisible'],
    );
  }
}

class QualityMetrics {
  final int wordCount;
  final bool hasImages;
  final bool hasDetailedRatings;
  final int qualityScore;

  QualityMetrics({
    required this.wordCount,
    required this.hasImages,
    required this.hasDetailedRatings,
    required this.qualityScore,
  });

  factory QualityMetrics.fromJson(Map<String, dynamic> json) {
    return QualityMetrics(
      wordCount: json['wordCount'],
      hasImages: json['hasImages'],
      hasDetailedRatings: json['hasDetailedRatings'],
      qualityScore: json['qualityScore'],
    );
  }
}

class ReviewImage {
  final String url;
  final String? thumbnail;
  final String? caption;
  final bool isProcessed;
  final DateTime uploadedAt;

  ReviewImage({
    required this.url,
    this.thumbnail,
    this.caption,
    required this.isProcessed,
    required this.uploadedAt,
  });

  factory ReviewImage.fromJson(Map<String, dynamic> json) {
    return ReviewImage(
      url: json['url'],
      thumbnail: json['thumbnail'],
      caption: json['caption'],
      isProcessed: json['isProcessed'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }
}

/* -------------------- STATS & PAGINATION -------------------- */

class RatingStats {
  final double averageRating;
  final int totalReviews;
  final Map<String, int> ratingDistribution;
  final AspectRatings aspectRatings;

  RatingStats({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.aspectRatings,
  });

  factory RatingStats.fromJson(Map<String, dynamic> json) {
    return RatingStats(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
      ratingDistribution:
          Map<String, int>.from(json['ratingDistribution']),
      aspectRatings: AspectRatings.fromJson(json['aspectRatings']),
    );
  }
}

class AspectRatings {
  final double quality;
  final double valueForMoney;
  final double delivery;
  final double accuracy;

  AspectRatings({
    required this.quality,
    required this.valueForMoney,
    required this.delivery,
    required this.accuracy,
  });

  factory AspectRatings.fromJson(Map<String, dynamic> json) {
    return AspectRatings(
      quality: (json['quality'] as num).toDouble(),
      valueForMoney: (json['valueForMoney'] as num).toDouble(),
      delivery: (json['delivery'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}

/* -------------------- META -------------------- */

class Meta {
  final DateTime timestamp;

  Meta({required this.timestamp});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
