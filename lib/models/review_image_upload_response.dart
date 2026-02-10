class ReviewImageUploadResponse {
  final bool success;
  final List<ReviewImage> images;
  final int count;

  ReviewImageUploadResponse({
    required this.success,
    required this.images,
    required this.count,
  });

  factory ReviewImageUploadResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return ReviewImageUploadResponse(
      success: json['success'] ?? false,
      images: (data['images'] as List? ?? [])
          .map((e) => ReviewImage.fromJson(e))
          .toList(),
      count: data['count'] ?? 0,
    );
  }
}

class ReviewImage {
  final String url;
  final String? thumbnail;
  final String caption;

  ReviewImage({
    required this.url,
    this.thumbnail,
    required this.caption,
  });

  factory ReviewImage.fromJson(Map<String, dynamic> json) {
    return ReviewImage(
      url: json['url'] ?? '',
      thumbnail: json['thumbnail'],
      caption: json['caption'] ?? '',
    );
  }
}
