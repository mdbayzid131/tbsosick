import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tbsosick/app.dart';
import 'package:tbsosick/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await Firebase.initializeApp();

  runApp(MyApp());
}