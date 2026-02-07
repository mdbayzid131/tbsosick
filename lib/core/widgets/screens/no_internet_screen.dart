import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/core/controllers/internet_controller.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final internet = Get.find<InternetController>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 80),
              const SizedBox(height: 16),
              const Text(
                'No Internet Connection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please check your internet and try again',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 40),
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
                onPressed: () {
                  if (internet.hasInternet.value) {
                    internet.setOnline();
                    Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
                  }
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
