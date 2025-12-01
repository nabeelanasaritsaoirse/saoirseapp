// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:get/get.dart';
import 'package:saoirse_app/models/notification_details_response_model.dart';

import '../../models/notification_response.dart';
import '../../services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService service = NotificationService();
var notificationDetails = Rx<NotificationModel?>(null);
var comments = <CommentModel>[].obs; // ADD THIS

var isDetailsLoading = false.obs;
  var notifications = <AppNotification>[].obs;
  var isLoading = false.obs;

  /// unread count
  var unreadCount = 0.obs;

  int page = 1;
  final int limit = 20;

  var hasMore = true.obs;

  @override
  void onInit() {
    fetchNotifications();
    fetchUnreadCount();
    super.onInit();
  }

  // Fetch Notifications
  Future<void> fetchNotifications() async {
    if (!hasMore.value) return;

    try {
      isLoading(true);

      final response = await service.fetchNotifications(page, limit);

      if (response != null && response.success) {
        notifications.addAll(response.data.notifications);
        hasMore.value = response.data.pagination.hasMore;
        page++;
      }
    } catch (e) {
      print("❌ Notification fetch error: $e");
    } finally {
      isLoading(false);
    }
  }

  // get notification details
  Future<void> getNotificationDetails(String id) async {
  try {
    isDetailsLoading(true);

    final response = await service.fetchNotificationDetails(id);

    if (response != null && response.success) {
      notificationDetails.value = response.data!.notification;

      /// Store comments
      comments.value = response.data!.comments;

      /// OPTIONAL: Store counts if needed later
      // commentCount.value = response.data!.commentsCount;
    }
  } catch (e) {
    log("❌ Error fetching notification details: $e");
  } finally {
    isDetailsLoading(false);
  }
}


Future<void> toggleLike(String notificationId) async {
  try {
    final response = await service.toggleLike(notificationId);

    if (response != null && response["success"] == true) {
      final data = response["data"];

      // Update notification details (Details Screen)
      if (notificationDetails.value != null) {
        notificationDetails.value =
            notificationDetails.value!.copyWith(
          isLikedByMe: data["isLiked"],
          likeCount: data["newLikeCount"],
        );
      }

      // Update list item (Notification List Screen)
      int index = notifications.indexWhere(
          (n) => n.notificationId == notificationId);

      if (index != -1) {
        notifications[index] = notifications[index].copyWith(
          isLikedByMe: data["isLiked"],
          likeCount: data["newLikeCount"],
        );
        notifications.refresh();
      }
    }
  } catch (e) {
    print("❌ Like toggle failed: $e");
  }
}




Future<void> markAsRead(String notificationId) async {
  try {
    final success = await service.markAsRead(notificationId);

    if (success) {
      // Update unread count
      if (unreadCount > 0) {
        unreadCount.value = unreadCount.value - 1;
      }

      // Update list item if exists
      int index = notifications.indexWhere(
        (n) => n.notificationId == notificationId,
      );

      if (index != -1) {
        // If your API has "isRead", uncomment below:
        // notifications[index] = notifications[index].copyWith(isRead: true);

        notifications.refresh();
      }
    }
  } catch (e) {
    print("❌ Mark as read update failed: $e");
  }
}


Future<void> addComment(String notificationId, String text) async {
  final trimmed = text.trim();

  print("📝 Raw text: '$text'");
  print("🧹 Trimmed text: '$trimmed'");

  if (trimmed.isEmpty) {
    print("⚠️ Comment is empty");
    return;
  }

  if (trimmed.length > 1000) {
    print("⚠️ Comment too long");
    return;
  }

  final urlRegex = RegExp(r'(https?:\/\/|www\.)');
  if (urlRegex.hasMatch(trimmed)) {
    print("⚠️ URLs not allowed");
    return;
  }

  try {
    isLoading(true);

    final body = {"text": trimmed};

    print("🚀 FINAL JSON SENT: ${body}");

    final response = await service.addComment(
      notificationId: notificationId,
      body: body,
    );

    print("📥 SERVER RESPONSE: $response");

    if (response != null && response["success"] == true) {
      final newComment = CommentModel.fromJson(response["data"]["comment"]);

      comments.insert(0, newComment);

      if (notificationDetails.value != null) {
        final old = notificationDetails.value!;
        notificationDetails.value = old.copyWith(
          commentCount: old.commentCount + 1,
        );
      }

      comments.refresh();
      print("✅ Comment added successfully!");
    } else {
      print("❌ API returned an error: ${response?["message"]}");
    }
  } catch (e) {
    print("❌ Add comment exception: $e");
  } finally {
    isLoading(false);
  }
}
  // To register FCM token
  Future<void> registerFCM(String token) async {
  log("Received fcm token ::::::: $token");
  final success = await service.registerFCMToken(token);

  if (success) {
    log("🔥 Controller: FCM token saved to server.");
  } else {
    log("❌ Controller: Failed to save FCM token.");
  }
}

// To remove FCM token
Future<void> removeFCM() async {
  final success = await service.removeFCMToken();

  if (success) {
    print("🧹 Controller: FCM token removed from backend.");
  } else {
    print("❌ Controller: Failed to remove FCM token.");
  }
}





  // Fetch Unread Count
  Future<void> fetchUnreadCount() async {
    final count = await service.getUnreadCount();
    if (count != null) unreadCount.value = count;
  }
}
