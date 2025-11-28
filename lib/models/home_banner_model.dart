class HomeBannerResponse {
  final bool success;
  final List<HomeBannerItem> data;

  HomeBannerResponse({
    required this.success,
    required this.data,
  });

  factory HomeBannerResponse.fromJson(Map<String, dynamic> json) {
    return HomeBannerResponse(
      success: json["success"] ?? false,
      data: (json["data"] as List<dynamic>? ?? [])
          .map((e) => HomeBannerItem.fromJson(e))
          .toList(),
    );
  }
}

class HomeBannerItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String altText;
  final String redirectType;
  final String? redirectValue;
  final int displayOrder;
  final bool isActive;

  HomeBannerItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.altText,
    required this.redirectType,
    required this.redirectValue,
    required this.displayOrder,
    required this.isActive,
  });

  factory HomeBannerItem.fromJson(Map<String, dynamic> json) {
    return HomeBannerItem(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      altText: json["altText"] ?? "",
      redirectType: json["redirectType"] ?? "",
      redirectValue: json["redirectValue"],
      displayOrder: json["displayOrder"] ?? 0,
      isActive: json["isActive"] ?? false,
    );
  }
}
