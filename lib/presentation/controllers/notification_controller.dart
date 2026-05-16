import 'package:get/get.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/notification_model.dart';
import 'package:tbsosick/data/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _repository = NotificationRepository();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxInt unreadCount = 0.obs;
  String? _nextCursor;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (isRefresh) {
      _nextCursor = null;
      _hasMore = true;
    }

    if (!_hasMore && !isRefresh) return;

    try {
      if (isRefresh) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      final response = await _repository.getNotifications(cursor: _nextCursor);

      if (response.statusCode == 200) {
        final notificationResponse = NotificationResponse.fromJson(response.data);
        
        if (isRefresh) {
          notifications.assignAll(notificationResponse.data);
        } else {
          notifications.addAll(notificationResponse.data);
        }

        _nextCursor = notificationResponse.meta.nextCursor;
        _hasMore = notificationResponse.meta.hasMore;
        unreadCount.value = notificationResponse.meta.unreadCount;
      }
    } catch (e) {
      Helpers.error('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await _repository.markAsRead(notificationId);
      if (response.statusCode == 200) {
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final old = notifications[index];
          if (!old.isRead) {
            notifications[index] = NotificationModel(
              id: old.id,
              userId: old.userId,
              type: old.type,
              title: old.title,
              subtitle: old.subtitle,
              resourceType: old.resourceType,
              resourceId: old.resourceId,
              link: old.link,
              isRead: true,
              readAt: DateTime.now(),
              icon: old.icon,
              createdAt: old.createdAt,
              updatedAt: DateTime.now(),
            );
            unreadCount.value = (unreadCount.value - 1).clamp(0, 999);
          }
        }
      }
    } catch (e) {
      Helpers.error('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await _repository.markAllAsRead();
      if (response.statusCode == 200) {
        for (var i = 0; i < notifications.length; i++) {
          if (!notifications[i].isRead) {
            final old = notifications[i];
            notifications[i] = NotificationModel(
              id: old.id,
              userId: old.userId,
              type: old.type,
              title: old.title,
              subtitle: old.subtitle,
              resourceType: old.resourceType,
              resourceId: old.resourceId,
              link: old.link,
              isRead: true,
              readAt: DateTime.now(),
              icon: old.icon,
              createdAt: old.createdAt,
              updatedAt: DateTime.now(),
            );
          }
        }
        unreadCount.value = 0;
      }
    } catch (e) {
      Helpers.error('Error marking all notifications as read: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final response = await _repository.deleteNotification(notificationId);
      if (response.statusCode == 200) {
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          if (!notifications[index].isRead) {
            unreadCount.value = (unreadCount.value - 1).clamp(0, 999);
          }
          notifications.removeAt(index);
        }
      }
    } catch (e) {
      Helpers.error('Error deleting notification: $e');
    }
  }
}
