import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:tbsosick/core/utils/helpers.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS এর জন্য
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: iosSettings);



    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        if (response.payload != null) {
          try {
            await OpenFile.open(response.payload);
          } catch (e) {
            Helpers.showDebugLog("Error opening file from notification: $e");
          }
        }
      },
    );
  }

  Future<void> showDownloadNotification({
    required String filePath,
    required String fileName,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'download_channel',
          'Downloads',
          channelDescription: 'Notifications for downloaded files',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: 'Download Complete',
      body: '$fileName has been downloaded.',
      notificationDetails: platformChannelSpecifics,
      payload: filePath,
    );
  }
}
