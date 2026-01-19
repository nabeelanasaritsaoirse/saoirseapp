import '../constants/app_constant.dart';
import '../constants/app_urls.dart';
import '../main.dart';
import '../models/notification_details_response_model.dart';
import '../models/notification_response.dart';
import '../services/api_service.dart';

class NotificationService {
  String? token; // IMPORTANT: dynamic token

  void updateToken(String newToken) {
    token = newToken;
  }

  Map<String, String> get headers =>
      {"Authorization": "Bearer $token", "Content-Type": "application/json"};

  // Fetch Notifications with pagination
  Future<NotificationResponse?> fetchNotifications(int page, int limit) async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}?page=$page&limit=$limit";

      final response = await APIService.getRequest(
        url: url,
        headers: headers,
        onSuccess: (data) => data,
      );

      if (response == null) return null;

      return NotificationResponse.fromJson(response);
    } catch (e) {
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
      return null;
    }
  }

//  to fetch notification details
  Future<NotificationDetailsResponse?> fetchNotificationDetails(
      String id) async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}/$id";

      final response = await APIService.getRequest(
        url: url,
        headers: headers,
        onSuccess: (data) => data,
      );

      if (response == null) return null;

      return NotificationDetailsResponse.fromJson(response);
    } catch (e) {
      return null;
    }
  }

// For like
  Future<Map<String, dynamic>?> toggleLike(String notificationId) async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}/$notificationId/like";

      final response = await APIService.postRequest(
        url: url,
        headers: {"Authorization": "Bearer $token"},
        onSuccess: (data) => data,
      );

      return response;
    } catch (e) {
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> addComment({
    required String notificationId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}/$notificationId/comments";

      final response = await APIService.postRequest(
        url: url,
        body: body,
        headers: headers,
        onSuccess: (data) => data,
      );

      return response;
    } catch (e) {
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

      final response = await APIService.postRequest(
        url: url,
        body: body,
        headers: headers,
        onSuccess: (data) => data,
      );

      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

// For remove FCM token
  Future<bool> removeFCMToken() async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}/remove-token";

      final response = await APIService.postRequest(
        url: url,
        body: {}, // empty body
        headers: headers,
        onSuccess: (data) => data,
      );

      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

// ==========================================================================================

  Future<bool> sendInAppWelcomeNotification({
    required String userName,
    required String token,
  }) async {
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

      return response != null && response["success"] == true;
    } catch (e) {
      return false;
    }
  }
}
