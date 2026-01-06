// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:saoirse_app/constants/app_constant.dart';
import 'package:saoirse_app/main.dart';
import 'package:saoirse_app/models/notification_details_response_model.dart';
import '../constants/app_urls.dart';
import '../models/notification_response.dart';
import '../services/api_service.dart';

class NotificationService {
  String? token; // IMPORTANT: dynamic token

  void updateToken(String newToken) {
    token = newToken;
    log("🔑 NotificationService token updated: $token");
  }

  Map<String, String> get headers =>
      {"Authorization": "Bearer $token", "Content-Type": "application/json"};

  // Fetch Notifications with pagination
  Future<NotificationResponse?> fetchNotifications(int page, int limit) async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}?page=$page&limit=$limit";

      print("🔔 Fetch Notifications URL: $url");

      final response = await APIService.getRequest(
        url: url,
        headers: headers,
        onSuccess: (data) => data,
      );

      if (response == null) return null;

      return NotificationResponse.fromJson(response);
    } catch (e) {
      print("❌ Notification fetch error: $e");
      return null;
    }
  }

  // ---- unread count API ----
  Future<int?> getUnreadCount() async {
    try {
      final url = AppURLs.UNREAD_NOTIFICATIONS;

      final response = await APIService.getRequest(
        url: url,
        headers: headers,
        onSuccess: (data) => data,
      );

      if (response == null) return null;

      return response["data"]["unreadCount"] ?? 0;
    } catch (e) {
      print("Unread count error: $e");
      return null;
    }
  }

//  to fetch notification details
  Future<NotificationDetailsResponse?> fetchNotificationDetails(
      String id) async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}/$id";

      print("🔎 Fetch Notification Details URL: $url");

      final response = await APIService.getRequest(
        url: url,
        headers: headers,
        onSuccess: (data) => data,
      );

      if (response == null) return null;

      return NotificationDetailsResponse.fromJson(response);
    } catch (e) {
      print("❌ Notification details fetch error: $e");
      return null;
    }
  }

// For like
  Future<Map<String, dynamic>?> toggleLike(String notificationId) async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}/$notificationId/like";

      final response = await APIService.postRequest(
        url: url,
        headers: {
          "Authorization": "Bearer $token"
        },
        onSuccess: (data) => data,
      );

      return response;
    } catch (e) {
      print("❌ Like toggle error: $e");
      return null;
    }
  }

// For Notification mark as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}/$notificationId/mark-read";

      final response = await APIService.postRequest(
        url: url,
        onSuccess: (data) => data,
        headers: headers,
      );

      if (response != null) {
        print("✅ Mark as Read Success for ID: $notificationId");
        return true;
      } else {
        print(
            "⚠️ Mark as Read Failed (API returned null) for ID: $notificationId");
        return false;
      }
    } catch (e) {
      log("❌ Mark as Read error: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> addComment({
    required String notificationId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}/$notificationId/comments";

      print("📡 POST → $url");
      log("📦 BODY SENT → $body");

      final response = await APIService.postRequest(
        url: url,
        body: body,
        headers: headers,
        onSuccess: (data) => data,
      );

      print("📩 RESPONSE → $response");

      return response;
    } catch (e) {
      log("❌ Add Comment Error: $e");
      return null;
    }
  }

// For register FCM Token
  Future<bool> registerFCMToken(String fcmToken) async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}/register-token";

      final body = {
        "fcmToken": fcmToken,
      };

      log("📡 Registering FCM Token → $fcmToken");

      final response = await APIService.postRequest(
        url: url,
        body: body,
        headers: headers,
        onSuccess: (data) => data,
      );

      if (response != null) {
        log("✅ FCM token registered successfully");
        return true;
      } else {
        log("⚠️ Failed to register FCM token (NULL response)");
        return false;
      }
    } catch (e) {
      log("❌ Register FCM Token Error → $e");
      return false;
    }
  }

// For remove FCM token
  Future<bool> removeFCMToken() async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}/remove-token";

      log("🗑 Removing FCM token from server...");

      final response = await APIService.postRequest(
        url: url,
        body: {}, // empty body
        headers: headers,
        onSuccess: (data) => data,
      );

      if (response != null) {
        log("✅ FCM token removed successfully");
        return true;
      } else {
        log("⚠️ Failed to remove FCM token (null response)");
        return false;
      }
    } catch (e) {
      log("❌ Remove FCM Token Error → $e");
      return false;
    }
  }

// ==========================================================================================

  Future<bool> sendInAppWelcomeNotification({
    required String userName,
    required String token,
  }) async {
    log("tocken reached in sendInAppWelcomeNotification ###### :$token");
    return await APIService.postRequest<bool>(
      url: AppURLs.NOTIFICATION_API,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: {
        "title": "Welcome back, $userName! 👋",
        "message": "Check out the latest deals and offers just for you.",
        "sendPush": false,
        "sendInApp": true,
      },
      onSuccess: (data) {
        /// Expected success response format:
        /// { "success": true, ... }
        if (data["success"] == true) {
          return true;
        }
        return false;
      },
    ).then((value) => value ?? false);
  }



Future<bool> sendCustomNotification({
  required String title,
  required String message,
  bool sendPush = true,
  bool sendInApp = true,
}) async {
  try {
    final token = await storage.read(AppConst.ACCESS_TOKEN);

    if (token == null || token.isEmpty) {
      log("❌ Notification token missing");
      return false;
    }

    final body = {
      "title": title,
      "message": message,
      "sendPush": sendPush,
      "sendInApp": sendInApp,
    };

    final response = await APIService.postRequest(
      url: AppURLs.NOTIFICATION_API,
      body: body,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      onSuccess: (json) => json,
    );

    log("📨 Notification response: $response");

    return response != null && response["success"] == true;
  } catch (e) {
    log("❌ sendCustomNotification Error: $e");
    return false;
  }
}


}
