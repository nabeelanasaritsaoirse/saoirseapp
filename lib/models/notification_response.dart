class NotificationResponse {
  final bool success;
  final NotificationData data;

  NotificationResponse({
    required this.success,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      data: NotificationData.fromJson(json['data']),
    );
  }
}

// --------------------------------------------------------------------

class NotificationData {
  final List<AppNotification> notifications;
  final Pagination pagination;

  NotificationData({
    required this.notifications,
    required this.pagination,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notifications: (json['notifications'] as List)
          .map((e) => AppNotification.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

// --------------------------------------------------------------------

class AppNotification {
  final String id;
  final String notificationId;
  final String type;
  final String title;
  final String body;
  final String? imageUrl;
  final String publishedAt;
  final String createdAt;

  // Optional fields (admin posts only)
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final bool commentsEnabled;
  final bool likesEnabled;
  final bool isLikedByMe;
  final CreatedBy? createdBy;

  AppNotification({
    required this.id,
    required this.notificationId,
    required this.type,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.publishedAt,
    required this.createdAt,

    // defaults for SYSTEM_NOTIFICATION
    this.likeCount = 0,
    this.commentCount = 0,
    this.viewCount = 0,
    this.commentsEnabled = false,
    this.likesEnabled = false,
    this.isLikedByMe = false,
    this.createdBy,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'],
      notificationId: json['notificationId'],
      type: json['type'],
      title: json['title'],
      body: json['body'],
      imageUrl: json['imageUrl'],
      publishedAt: json['publishedAt'],
      createdAt: json['createdAt'],

      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      commentsEnabled: json['commentsEnabled'] ?? false,
      likesEnabled: json['likesEnabled'] ?? false,
      isLikedByMe: json['isLikedByMe'] ?? false,
      createdBy:
          json['createdBy'] != null ? CreatedBy.fromJson(json['createdBy']) : null,
    );
  }

  AppNotification copyWith({
    int? likeCount,
    bool? isLikedByMe,
  }) {
    return AppNotification(
      id: id,
      notificationId: notificationId,
      type: type,
      title: title,
      body: body,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      createdAt: createdAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount,
      viewCount: viewCount,
      commentsEnabled: commentsEnabled,
      likesEnabled: likesEnabled,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      createdBy: createdBy,
    );
  }
}

// --------------------------------------------------------------------

class CreatedBy {
  final String id;
  final String name;
  final String avatar;

  CreatedBy({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'],
      name: json['name'],
      avatar: json['avatar'] ?? "",
    );
  }
}

// --------------------------------------------------------------------

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasMore;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
      hasMore: json['hasMore'],
    );
  }
}





