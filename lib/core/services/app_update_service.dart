import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';

/// ============================================================================
/// APP UPDATE SERVICE (AppUpdateService)
/// ============================================================================
/// Manages cross-platform app updates:
/// - Android: Google Play In-App Updates (Flexible bottom sheet / Immediate)
/// - iOS: App Store version lookup & update dialog
/// ============================================================================
class AppUpdateService {
  /// Checks for available app updates on Android (Play Store) & iOS (App Store)
  static Future<void> checkForUpdate() async {
    try {
      if (kIsWeb) return;

      if (Platform.isAndroid) {
        await _checkAndroidUpdate();
      } else if (Platform.isIOS) {
        await _checkIosUpdate();
      }
    } catch (e) {
      Helpers.debug('AppUpdateService: Error during update check: $e');
    }
  }

  /// Android: Handles Google Play In-App Update flow (Flexible & Immediate)
  static Future<void> _checkAndroidUpdate() async {
    try {
      Helpers.debug('AppUpdateService: Checking Google Play Store update...');
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.flexibleUpdateAllowed) {
          Helpers.debug('AppUpdateService: Starting flexible update bottom sheet...');
          final status = await InAppUpdate.startFlexibleUpdate();
          if (status == AppUpdateResult.success) {
            await InAppUpdate.completeFlexibleUpdate();
          }
        } else if (updateInfo.immediateUpdateAllowed) {
          Helpers.debug('AppUpdateService: Performing immediate update...');
          await InAppUpdate.performImmediateUpdate();
        }
      } else {
        Helpers.debug('AppUpdateService: App is up to date on Google Play Store.');
      }
    } catch (e) {
      // In-App Update only works on signed production/test builds installed via Play Store.
      // Catches debug errors (e.g. TASK_FAILURE / APP_NOT_OWNED) safely.
      Helpers.debug('AppUpdateService: Google Play update check bypassed ($e)');
    }
  }

  /// iOS: Checks App Store for newer version using iTunes Lookup API
  static Future<void> _checkIosUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final bundleId = packageInfo.packageName;
      final currentVersion = packageInfo.version;

      final dio = Dio();
      final response = await dio.get('https://itunes.apple.com/lookup?bundleId=$bundleId');

      if (response.statusCode == 200 && response.data != null) {
        final results = response.data['results'] as List?;
        if (results != null && results.isNotEmpty) {
          final appStoreVersion = results[0]['version'] as String?;
          final trackViewUrl = results[0]['trackViewUrl'] as String?;

          if (appStoreVersion != null && _isVersionHigher(appStoreVersion, currentVersion)) {
            _showIosUpdateDialog(appStoreVersion, trackViewUrl);
          }
        }
      }
    } catch (e) {
      Helpers.debug('AppUpdateService: iOS App Store update check bypassed ($e)');
    }
  }

  /// Helper to compare semver strings (e.g., "1.0.9" vs "1.0.8")
  static bool _isVersionHigher(String latestVersion, String currentVersion) {
    try {
      List<int> latestParts = latestVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      List<int> currentParts = currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      for (int i = 0; i < latestParts.length; i++) {
        int current = i < currentParts.length ? currentParts[i] : 0;
        if (latestParts[i] > current) return true;
        if (latestParts[i] < current) return false;
      }
    } catch (e) {
      Helpers.debug('AppUpdateService: Version parsing error: $e');
    }
    return false;
  }

  /// Displays iOS App Store update prompt dialog
  static void _showIosUpdateDialog(String newVersion, String? appStoreUrl) {
    Get.defaultDialog(
      title: 'Update Available',
      middleText: 'A new version ($newVersion) of the app is available on the App Store. Please update for the best experience.',
      textConfirm: 'Update Now',
      textCancel: 'Later',
      confirmTextColor: null,
      onConfirm: () async {
        Get.back();
        if (appStoreUrl != null && appStoreUrl.isNotEmpty) {
          final uri = Uri.parse(appStoreUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
    );
  }
}
