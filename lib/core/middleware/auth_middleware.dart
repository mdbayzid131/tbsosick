
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import '../services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthService _authService = Get.put(AuthService());

  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in
    if (!_authService.isLoggedIn.value) {
      return const RouteSettings(name: AppRoutes.LOGIN);
    }
    return null;
  }
}
