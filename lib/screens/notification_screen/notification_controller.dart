import 'package:get/get.dart';
import '../../models/notification_response.dart';
import '../../services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService service = NotificationService();

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
    
  // Fetch Unread Count
    Future<void> fetchUnreadCount() async {
    final count = await service.getUnreadCount();
    if (count != null) unreadCount.value = count;
  }
}
