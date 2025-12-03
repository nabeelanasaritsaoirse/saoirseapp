import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:saoirse_app/screens/notification_details/notification_details_screen.dart';

class NotificationServiceHelper {
  static final _plugin = FlutterLocalNotificationsPlugin();

  // *************************************************************
  // INIT LOCAL NOTIFICATION SYSTEM
  // *************************************************************
  static Future<void> initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload?.toString();

        log("🔵 Local Notification Tapped → payload = $payload");

        if (payload != null && payload.isNotEmpty) {
          handleNotificationTap({"id": payload});
        }
      },
    );

    // Create Notification Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications',
      importance: Importance.max,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // *************************************************************
  // SHOW LOCAL NOTIFICATION (FOREGROUND)
  // *************************************************************
  static void showFlutterNotification(RemoteMessage message) {
    final notif = message.notification;
    if (notif == null) return;

    final id = message.data["id"]?.toString();

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    _plugin.show(
      notif.hashCode,
      notif.title,
      notif.body,
      const NotificationDetails(android: androidDetails),
      payload: id ?? "",
    );
  }

  // *************************************************************
  // HANDLE NOTIFICATION TAP → NAVIGATE TO DETAILS
  // *************************************************************
  static void handleNotificationTap(Map<String, dynamic> data) {
    final id = data["id"]?.toString();

    if (id == null || id.isEmpty) {
      log("⚠️ Notification tap ignored — ID missing");
      return;
    }

    log("➡ Opening Notification Details for ID = $id");

    // Delay navigation until app is ready
    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        Get.to(() => NotificationDetailsScreen(notificationId: id));
      } catch (e) {
        log("❌ Navigation failed: $e");
      }
    });
  }
}
