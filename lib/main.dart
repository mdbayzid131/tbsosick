import 'package:flutter/material.dart';
import 'package:tbsosick/app.dart';
import 'package:tbsosick/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ApiClient().init();
  await NotificationService().init();

  runApp(MyApp());
}
