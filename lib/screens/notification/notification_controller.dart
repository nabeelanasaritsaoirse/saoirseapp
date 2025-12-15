// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:get/get.dart';

import '../../models/notification_details_response_model.dart';
import '../../models/notification_response.dart';
import '../../services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService service = NotificationService();

  // 🔑 Token will be set after login
  String? token;

  // DATA
  var notifications = <AppNotification>[].obs;
  var notificationDetails = Rx<NotificationModel?>(null);
  var comments = <CommentModel>[].obs;

  // STATES
  var isLoading = false.obs;
  var isDetailsLoading = false.obs;
  var unreadCount = 0.obs;

  // PAGINATION
  int page = 1;
  final int limit = 20;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    log("🔔 NotificationController initialized — waiting for token…");
  }

  // ------------------------------------------------------------
  // 🔑 Update token after login
  // ------------------------------------------------------------
  void updateToken(String newToken) {
    token = newToken;
    service.updateToken(newToken);
    log("🔑 NotificationController token updated");

    page = 1;
    notifications.clear();
    hasMore.value = true;

    fetchNotifications(); // <-- ADD THIS
    fetchUnreadCount(); // <-- ADD THIS
  }

  bool get hasToken => token != null && token!.isNotEmpty;

  // ------------------------------------------------------------
  // 📩 Fetch Notifications
  // ------------------------------------------------------------
  Future<void> fetchNotifications() async {
    if (!hasMore.value || isLoading.value) return;

    try {
      isLoading(true);

      final response = await service.fetchNotifications(page, limit);

      if (response != null && response.success) {
        notifications.addAll(response.data.notifications);
        // if less than limit returned → no more pages
        if (response.data.notifications.length < limit) {
          hasMore.value = false;
        } else {
          page++;
        }
      }
    } catch (e) {
      log("❌ Notification fetch error: $e");
    } finally {
      isLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 📌 Single Notification Details
  // ------------------------------------------------------------
  Future<void> getNotificationDetails(String id) async {
    if (!hasToken) {
      log("🚫 No token → getNotificationDetails skipped");
      return;
    }

    try {
      isDetailsLoading(true);

      final response = await service.fetchNotificationDetails(id);

      if (response != null && response.success) {
        notificationDetails.value = response.data!.notification;
        comments.value = response.data!.comments;
      }
    } catch (e) {
      log("❌ Error fetching notification details: $e");
    } finally {
      isDetailsLoading(false);
    }
  }

  // ------------------------------------------------------------
  // ❤️ Toggle Like
  // ------------------------------------------------------------
  Future<void> toggleLike(String notificationId) async {
    if (!hasToken) {
      log("🚫 No token → toggleLike skipped");
      return;
    }

    try {
      final response = await service.toggleLike(notificationId);

      if (response != null && response["success"] == true) {
        final data = response["data"];

        // Update details screen
        if (notificationDetails.value != null) {
          notificationDetails.value = notificationDetails.value!.copyWith(
            isLikedByMe: data["isLiked"],
            likeCount: data["newLikeCount"],
          );
        }

        // Update list screen
        final index =
            notifications.indexWhere((n) => n.notificationId == notificationId);

        if (index != -1) {
          notifications[index] = notifications[index].copyWith(
            isLikedByMe: data["isLiked"],
            likeCount: data["newLikeCount"],
          );
          notifications.refresh();
        }
      }
    } catch (e) {
      log("❌ Like toggle failed: $e");
    }
  }

  // ------------------------------------------------------------
  // ✔ Mark as Read
  // ------------------------------------------------------------
  Future<void> markAsRead(String notificationId) async {
    if (!hasToken) return;

    try {
      final success = await service.markAsRead(notificationId);

      if (success) {
        if (unreadCount.value > 0) {
          unreadCount.value -= 1;
        }

        int index =
            notifications.indexWhere((n) => n.notificationId == notificationId);

        if (index != -1) {
          // If backend returns isRead, update here
          notifications.refresh();
        }
      }
    } catch (e) {
      log("❌ Mark as read failed: $e");
    }
  }

  // ------------------------------------------------------------
  // 💬 Add Comment
  // ------------------------------------------------------------
  Future<void> addComment(String notificationId, String text) async {
    if (!hasToken) return;

    final trimmed = text.trim();

    if (trimmed.isEmpty) {
      log("⚠️ Empty comment");
      return;
    }
    if (trimmed.length > 1000) {
      log("⚠️ Comment too long");
      return;
    }
    final urlRegex = RegExp(r'(https?:\/\/|www\.)');
    if (urlRegex.hasMatch(trimmed)) {
      log("⚠️ URLs not allowed in comments");
      return;
    }

    try {
      isLoading(true);

      final response = await service.addComment(
        notificationId: notificationId,
        body: {"text": trimmed},
      );

      if (response != null && response["success"] == true) {
        final newComment = CommentModel.fromJson(response["data"]["comment"]);

        comments.insert(0, newComment);

        if (notificationDetails.value != null) {
          notificationDetails.value = notificationDetails.value!.copyWith(
            commentCount: notificationDetails.value!.commentCount + 1,
          );
        }

        comments.refresh();
      }
    } catch (e) {
      log("❌ Add comment failed: $e");
    } finally {
      isLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 🔥 Register FCM Token
  // ------------------------------------------------------------
  Future<void> registerFCM(String fcmToken) async {
    if (!hasToken) {
      log("🚫 No token → registerFCM skipped");
      return;
    }

    log("🔥 Registering FCM → $fcmToken");

    final success = await service.registerFCMToken(fcmToken);

    if (success) {
      log("✅ FCM token registered");
    } else {
      log("❌ Failed to register FCM token");
    }
  }

  // ------------------------------------------------------------
  // 🗑 Remove FCM Token
  // ------------------------------------------------------------
  Future<void> removeFCM() async {
    if (!hasToken) return;

    final success = await service.removeFCMToken();

    if (success) {
      log("🧹 FCM token removed");
    } else {
      log("❌ Failed to remove FCM token");
    }
  }

  Future<void> refreshNotifications() async {
    page = 1;
    notifications.clear();
    hasMore.value = true;
    await fetchNotifications();
  }

  // ------------------------------------------------------------
  // 🔢 Unread Count
  // ------------------------------------------------------------
  Future<void> fetchUnreadCount() async {
    if (!hasToken) {
      log("🚫 No token → unread count skipped");
      return;
    }

    final count = await service.getUnreadCount();
    if (count != null) unreadCount.value = count;
  }

  // ------------------------------------------------------------
  // 🎉 Send In-App Welcome Notification
  // ------------------------------------------------------------
  Future<void> sendWelcomeNotification(String userName) async {
    if (!hasToken) {
      log("🚫 No token → sendWelcomeNotification skipped");
      return;
    }

    log("📩 Sending welcome notification for: $userName");

    final success = await service.sendInAppWelcomeNotification(
      userName: userName,
      token: token!,
    );

    if (success) {
      log("🎉 Welcome notification sent!");
    } else {
      log("❌ Failed to send welcome notification");
    }
  }

  // FOR ORDER CONFIRMATION
  Future<void> sendOrderConfirmation(String userName) async {
    if (!hasToken) {
      log("🚫 No token → sendOrderConfirmation skipped");
      return;
    }

    log("📦 Sending Order Confirmation Notification → $userName");

    final success = await service.sendCustomNotification(
      title: "Thank you, $userName!",
      message: "Your order has been confirmed and will be delivered soon.",
      sendPush: true,
      sendInApp: true,
    );

    if (success) {
      log("🎉 Order Confirmation Notification Sent Successfully");

      /// refresh notifications
      refreshNotifications();
      fetchUnreadCount();
    } else {
      log("❌ Failed to send order confirmation notification");
    }
  }

  /// 🚨 Send Only Push Notification (Urgent Alert)
  Future<void> sendUrgentAlert() async {
    if (!hasToken) {
      log("🚫 No token → sendUrgentAlert skipped");
      return;
    }

    log("🚨 Sending Urgent Push Notification");

    final success = await service.sendCustomNotification(
      title: "⚡ Flash Sale Alert!",
      message: "Limited time offer: 50% OFF on all products. Shop now!",
      sendPush: true, // ✔ Push notification
      sendInApp: false, // ❌ Don't show in notification feed
    );

    if (success) {
      log("🎉 Urgent Push Notification Sent Successfully");
    } else {
      log("❌ Failed to send urgent push notification");
    }
  }
}
