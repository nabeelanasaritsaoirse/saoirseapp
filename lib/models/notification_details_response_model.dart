class NotificationDetailsResponse {
  final bool success;
  final NotificationData? data;

  NotificationDetailsResponse({
    required this.success,
    this.data,
  });

  factory NotificationDetailsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationDetailsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? NotificationData.fromJson(json['data'])
          : null,
    );
  }
}

class NotificationData {
  final NotificationModel notification;
  final List<CommentModel> comments;
  final int commentsCount;
  final bool hasMoreComments;

  NotificationData({
    required this.notification,
    required this.comments,
    required this.commentsCount,
    required this.hasMoreComments,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notification: NotificationModel.fromJson(json['notification']),
      comments: json['comments'] != null
          ? List<CommentModel>.from(
              json['comments'].map((x) => CommentModel.fromJson(x)))
          : [],
      commentsCount: json['commentsCount'] ?? 0,
      hasMoreComments: json['hasMoreComments'] ?? false,
    );
  }
}

class NotificationModel {
  final String notificationId;
  final String id;
  final String type;
  final String title;
  final String body;
  final String? imageUrl;
  final String publishedAt;
  final String createdAt;
  final String postType;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final bool commentsEnabled;
  final bool likesEnabled;
  final bool isLikedByMe;
  final CreatedBy createdBy;

  NotificationModel({
    required this.notificationId,
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.publishedAt,
    required this.createdAt,
    required this.postType,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.commentsEnabled,
    required this.likesEnabled,
    required this.isLikedByMe,
    required this.createdBy,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] ?? "",
      id: json['_id'] ?? "",
      type: json['type'] ?? "",
      title: json['title'] ?? "",
      body: json['body'] ?? "",
      imageUrl: json['imageUrl'],
      publishedAt: json['publishedAt'] ?? "",
      createdAt: json['createdAt'] ?? "",
      postType: json['postType'] ?? "",
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      commentsEnabled: json['commentsEnabled'] ?? false,
      likesEnabled: json['likesEnabled'] ?? false,
      isLikedByMe: json['isLikedByMe'] ?? false,
      createdBy: CreatedBy.fromJson(json['createdBy']),
    );
  }

  NotificationModel copyWith({
  int? likeCount,
  bool? isLikedByMe,
  int? commentCount,
}) {
  return NotificationModel(
    notificationId: notificationId,
    id: id,
    type: type,
    title: title,
    body: body,
    imageUrl: imageUrl,
    publishedAt: publishedAt,
    createdAt: createdAt,
    postType: postType,
    likeCount: likeCount ?? this.likeCount,
    commentCount: commentCount ?? this.commentCount,
    viewCount: viewCount,
    commentsEnabled: commentsEnabled,
    likesEnabled: likesEnabled,
    isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    createdBy: createdBy,
  );
}

}

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
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      avatar: json['avatar'] ?? "",
    );
  }
}

class CommentModel {
  final String? id;
  final String? commentId;
  final String? notificationId;
  final String? userId;
  final String? userName;
  final String? userAvatar;
  final String? text;
  final bool? isDeleted;
  final bool? deletedByAdmin;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final bool? isMyComment;

  CommentModel({
    this.id,
    this.commentId,
    this.notificationId,
    this.userId,
    this.userName,
    this.userAvatar,
    this.text,
    this.isDeleted,
    this.deletedByAdmin,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isMyComment,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'],
      commentId: json['commentId'],
      notificationId: json['notificationId'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      text: json['text'],
      isDeleted: json['isDeleted'],
      deletedByAdmin: json['deletedByAdmin'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      isMyComment: json['isMyComment'],
    );
  }

  
}






