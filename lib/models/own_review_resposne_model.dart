class OwnReviewResponse {
  final bool success;
  final String message;
  final OwnReviewData data;
  final Meta meta;

  OwnReviewResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory OwnReviewResponse.fromJson(Map<String, dynamic> json) {
    return OwnReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: OwnReviewData.fromJson(json['data'] ?? {}),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'meta': meta.toJson(),
    };
  }
}

class OwnReviewData {
  final List<Review> reviews;
  final Pagination pagination;

  OwnReviewData({
    required this.reviews,
    required this.pagination,
  });

  factory OwnReviewData.fromJson(Map<String, dynamic> json) {
    return OwnReviewData(
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => Review.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class Review {
  final String id;
  final DetailedRatings detailedRatings;
  final VariantInfo variantInfo;
  final Helpfulness helpfulness;
  final SellerResponse sellerResponse;
  final QualityMetrics qualityMetrics;
  final AutoModeration autoModeration;
  final String user;
  final String product;
  final String order;
  final int rating;
  final String title;
  final String comment;
  final List<ReviewImages> images;
  final String userName;
  final String userProfilePicture;
  final String productName;
  final String productId;
  final bool verifiedPurchase;
  final DateTime? purchaseDate;
  final int orderValue;
  final String status;
  final int editCount;
  final String moderationNote;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Review({
    required this.id,
    required this.detailedRatings,
    required this.variantInfo,
    required this.helpfulness,
    required this.sellerResponse,
    required this.qualityMetrics,
    required this.autoModeration,
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
    this.purchaseDate,
    required this.orderValue,
    required this.status,
    required this.editCount,
    required this.moderationNote,
    this.createdAt,
    this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? '',
      detailedRatings:
          DetailedRatings.fromJson(json['detailedRatings'] ?? {}),
      variantInfo: VariantInfo.fromJson(json['variantInfo'] ?? {}),
      helpfulness: Helpfulness.fromJson(json['helpfulness'] ?? {}),
      sellerResponse:
          SellerResponse.fromJson(json['sellerResponse'] ?? {}),
      qualityMetrics:
          QualityMetrics.fromJson(json['qualityMetrics'] ?? {}),
      autoModeration:
          AutoModeration.fromJson(json['autoModeration'] ?? {}),
      user: json['user'] ?? '',
      product: json['product'] ?? '',
      order: json['order'] ?? '',
      rating: json['rating'] ?? 0,
      title: json['title'] ?? '',
      comment: json['comment'] ?? '',
      images: (json['images'] as List? ?? [])
          .map((e) => ReviewImages.fromJson(e))
          .toList(),
      userName: json['userName'] ?? '',
      userProfilePicture: json['userProfilePicture'] ?? '',
      productName: json['productName'] ?? '',
      productId: json['productId'] ?? '',
      verifiedPurchase: json['verifiedPurchase'] ?? false,
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.tryParse(json['purchaseDate'])
          : null,
      orderValue: json['orderValue'] ?? 0,
      status: json['status'] ?? '',
      editCount: json['editCount'] ?? 0,
      moderationNote: json['moderationNote'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'detailedRatings': detailedRatings.toJson(),
      'variantInfo': variantInfo.toJson(),
      'helpfulness': helpfulness.toJson(),
      'sellerResponse': sellerResponse.toJson(),
      'qualityMetrics': qualityMetrics.toJson(),
      'autoModeration': autoModeration.toJson(),
      'user': user,
      'product': product,
      'order': order,
      'rating': rating,
      'title': title,
      'comment': comment,
      'images': images.map((e) => e.toJson()).toList(),
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'productName': productName,
      'productId': productId,
      'verifiedPurchase': verifiedPurchase,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'orderValue': orderValue,
      'status': status,
      'editCount': editCount,
      'moderationNote': moderationNote,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

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
      quality: json['quality'] ?? 0,
      valueForMoney: json['valueForMoney'] ?? 0,
      delivery: json['delivery'] ?? 0,
      accuracy: json['accuracy'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'quality': quality,
        'valueForMoney': valueForMoney,
        'delivery': delivery,
        'accuracy': accuracy,
      };
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

  Map<String, dynamic> toJson() => {
        'variantId': variantId,
        'variantName': variantName,
        'color': color,
        'size': size,
        'sku': sku,
      };
}

class Helpfulness {
  final int upvotes;
  final int downvotes;
  final int score;
  final List<dynamic> voters;

  Helpfulness({
    required this.upvotes,
    required this.downvotes,
    required this.score,
    required this.voters,
  });

  factory Helpfulness.fromJson(Map<String, dynamic> json) {
    return Helpfulness(
      upvotes: json['upvotes'] ?? 0,
      downvotes: json['downvotes'] ?? 0,
      score: json['score'] ?? 0,
      voters: json['voters'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'upvotes': upvotes,
        'downvotes': downvotes,
        'score': score,
        'voters': voters,
      };
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
      respondedAt: json['respondedAt'] != null
          ? DateTime.tryParse(json['respondedAt'])
          : null,
      isVisible: json['isVisible'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'respondedBy': respondedBy,
        'respondedByEmail': respondedByEmail,
        'respondedAt': respondedAt?.toIso8601String(),
        'isVisible': isVisible,
      };
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
      wordCount: json['wordCount'] ?? 0,
      hasImages: json['hasImages'] ?? false,
      hasDetailedRatings: json['hasDetailedRatings'] ?? false,
      qualityScore: json['qualityScore'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'wordCount': wordCount,
        'hasImages': hasImages,
        'hasDetailedRatings': hasDetailedRatings,
        'qualityScore': qualityScore,
      };
}

class AutoModeration {
  final bool isFlagged;
  final String? flagReason;
  final int confidence;

  AutoModeration({
    required this.isFlagged,
    this.flagReason,
    required this.confidence,
  });

  factory AutoModeration.fromJson(Map<String, dynamic> json) {
    return AutoModeration(
      isFlagged: json['isFlagged'] ?? false,
      flagReason: json['flagReason'],
      confidence: json['confidence'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'isFlagged': isFlagged,
        'flagReason': flagReason,
        'confidence': confidence,
      };
}

class ReviewImages {
  final String url;
  final String? thumbnail;
  final String caption;
  final bool isProcessed;
  final DateTime? uploadedAt;

  ReviewImages({
    required this.url,
    this.thumbnail,
    required this.caption,
    required this.isProcessed,
    this.uploadedAt,
  });

  factory ReviewImages.fromJson(Map<String, dynamic> json) {
    return ReviewImages(
      url: json['url'] ?? '',
      thumbnail: json['thumbnail'],
      caption: json['caption'] ?? '',
      isProcessed: json['isProcessed'] ?? false,
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.tryParse(json['uploadedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'thumbnail': thumbnail,
        'caption': caption,
        'isProcessed': isProcessed,
        'uploadedAt': uploadedAt?.toIso8601String(),
      };
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
      total: json['total'] ?? 0,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'page': page,
        'limit': limit,
        'totalPages': totalPages,
      };
}

class Meta {
  final DateTime? timestamp;

  Meta({this.timestamp});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp?.toIso8601String(),
      };
}
