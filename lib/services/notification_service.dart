import 'package:saoirse_app/main.dart';

import '../constants/app_constant.dart' show AppConst;
import '../constants/app_urls.dart';
import '../models/notification_response.dart';
import '../services/api_service.dart';

class NotificationService {
  final token = storage.read(AppConst.ACCESS_TOKEN);

  // Fetch Notifications with pagination
  Future<NotificationResponse?> fetchNotifications(int page, int limit) async {
    try {
      final url = "${AppURLs.NOTIFICATIONS}?page=$page&limit=$limit";

      print("🔔 Fetch Notifications URL: $url");

      final response = await APIService.getRequest(
        url: url,
        headers: {
          "Authorization": "Bearer $token",
        },
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
        headers: {
          "Authorization": "Bearer $token",
        },
        onSuccess: (data) => data,
      );

      if (response == null) return null;

      return response["data"]["unreadCount"] ?? 0;
    } catch (e) {
      print("Unread count error: $e");
      return null;
    }
  }
}
