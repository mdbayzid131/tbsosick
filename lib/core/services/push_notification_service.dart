import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/presentation/controllers/notification_controller.dart';

/// ===================== FIREBASE NOTIFICATION SERVICE =====================
/// Handles Firebase Cloud Messaging (FCM) push notifications.
/// Requires: firebase_core, firebase_messaging
/// Also needs google-services.json (Android) and GoogleService-Info.plist (iOS).

/// 🔥 Background handler — must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Helpers.debug('📬 Background Message: ${message.messageId}');
}

class FirebaseNotificationService {
  FirebaseNotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Callback for foreground messages
  static void Function(RemoteMessage)? onForegroundMessage;

  /// Callback for notification tap (app in background)
  static void Function(RemoteMessage)? onNotificationTap;

  /// Callback for FCM token refresh
  static void Function(String)? onTokenRefresh;

  /// Initialize FCM: permissions, token, listeners, background handler
  static Future<String?> initialize() async {
    // Request permission (Android auto-grants, iOS requires this)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    Helpers.debug(
      '🔐 Push Notification Permission Status: ${settings.authorizationStatus}',
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      Helpers.warning('🚫 Push Notification Permission Denied by user');
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      Helpers.info('✅ Push Notification Permission Granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Helpers.warning('⚠️ Push Notification Permission Provisional (iOS)');
    }

    // Get FCM token
    String? token;
    try {
      if (Platform.isIOS) {
        // iOS-এ APNS token পেতে সময় লাগতে পারে, তাই কিছুটা অপেক্ষা করা ভালো
        String? apnsToken = await _messaging.getAPNSToken();
        int retryCount = 0;
        while (apnsToken == null && retryCount < 3) {
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await _messaging.getAPNSToken();
          retryCount++;
          Helpers.debug('⏳ Waiting for APNS Token... (Retry: $retryCount)');
        }
      }

      token = await _messaging.getToken();
      Helpers.info('🔑 FCM Token: $token');
    } catch (e) {
      Helpers.error('❌ Error getting FCM Token: $e');
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      Helpers.info('🔄 FCM Token refreshed: $newToken');
      onTokenRefresh?.call(newToken);
    });

    // Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Helpers.info('📨 Foreground Message: ${message.notification?.title}');

      // Trigger a local notification banner in the foreground
      // final notification = message.notification;
      // if (notification != null) {
      //   NotificationService().showPushNotification(
      //     title: notification.title ?? '',
      //     body: notification.body ?? '',
      //     payload: message.data.toString(),
      //   );
      // }

      // Sync and update the UI unread notification count
      if (Get.isRegistered<NotificationController>()) {
        final notificationController = Get.find<NotificationController>();
        notificationController.fetchNotifications(isRefresh: true);
        Helpers.info('🔄 Refreshed notifications in UI from Foreground Push');
      }

      onForegroundMessage?.call(message);
    });

    // Notification tap (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Helpers.info('🔔 Notification clicked: ${message.data}');
      onNotificationTap?.call(message);
    });

    // App opened from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Helpers.info('🚀 Opened from terminated: ${initialMessage.data}');
      onNotificationTap?.call(initialMessage);
    }

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    return token;
  }

  /// Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    Helpers.debug('Subscribed to topic: $topic');
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    Helpers.debug('Unsubscribed from topic: $topic');
  }
}
