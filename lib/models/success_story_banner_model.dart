class SuccessStoryResponse {
  final bool success;
  final List<SuccessStoryItem> data;

  SuccessStoryResponse({
    required this.success,
    required this.data,
  });

  factory SuccessStoryResponse.fromJson(Map<String, dynamic> json) {
    return SuccessStoryResponse(
      success: json["success"] ?? false,
      data: (json["data"] as List<dynamic>? ?? [])
          .map((e) => SuccessStoryItem.fromJson(e))
          .toList(),
    );
  }
}

class SuccessStoryItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String altText;
  final int imageWidth;
  final int imageHeight;
  final int displayOrder;
  final String platform;
  final int views;

  SuccessStoryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.altText,
    required this.imageWidth,
    required this.imageHeight,
    required this.displayOrder,
    required this.platform,
    required this.views,
  });

  factory SuccessStoryItem.fromJson(Map<String, dynamic> json) {
    return SuccessStoryItem(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      altText: json["altText"] ?? "",
      imageWidth: json["imageWidth"] ?? 0,
      imageHeight: json["imageHeight"] ?? 0,
      displayOrder: json["displayOrder"] ?? 0,
      platform: json["platform"] ?? "",
      views: json["views"] ?? 0,
    );
  }
}
