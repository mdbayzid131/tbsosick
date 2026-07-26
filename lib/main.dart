import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tbsosick/app.dart';
import 'package:tbsosick/core/services/notification_service.dart';
import 'package:tbsosick/core/services/push_notification_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/firebase_options.dart';

import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow runtime fetching of Google Fonts if not found in local assets
  GoogleFonts.config.allowRuntimeFetching = true;

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await NotificationService().init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Helpers.info("Firebase initialized: ${Firebase.apps.length} apps");
  } catch (e) {
    Helpers.error("Firebase initialization failed: $e");
  }
  await FirebaseNotificationService.setupInterceptors();

  runApp(MyApp());
}
