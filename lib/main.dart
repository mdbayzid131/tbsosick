import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tbsosick/app.dart';
import 'package:tbsosick/core/services/notification_service.dart';
import 'package:tbsosick/core/services/push_notifecation_servies.dart';
import 'package:tbsosick/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase initialized: ${Firebase.apps.length} apps");
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  await FirebaseNotificationService.initialize();

  runApp(MyApp());
}