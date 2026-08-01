import 'package:get/get.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SnackBarType { success, error, info, warning, secondary }

/// ===================== HELPERS =====================
/// Common utility functions used across the app.
class Helpers {
  Helpers._();

  // ──────────────────── TIME FORMATTING ────────────────────

  /// Format seconds to "mm:ss" (e.g., 125 → "02:05")
  static String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  /// Format DateTime to "time ago" string (e.g., "5m ago")
  static String timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays >= 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays >= 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  /// Format seconds to "HH:mm:ss" (e.g., 3661 → "01:01:01")
  static String formatDuration(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final mins = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$mins:$secs';
  }

  // ──────────────────── LOGGING ────────────────────

  /// General debug log (only in debug mode)
  static void debug(String message) {
    if (!kDebugMode) return;
    debugPrint('');
    debugPrint('🔍🔍🔍 DEBUG: $message');
    debugPrint('');
  }

  /// Info-level log
  static void info(String message) {
    if (!kDebugMode) return;
    debugPrint('');
    debugPrint('ℹ️ℹ️ℹ️ℹ INFO: $message');
    debugPrint('');
  }

  /// Warning-level log
  static void warning(String message) {
    if (!kDebugMode) return;
    debugPrint('');
    debugPrint('⚠️⚠️⚠️ WARNING: $message');
    debugPrint('');
  }

  /// Error-level log
  static void error(String message) {
    if (!kDebugMode) return;
    debugPrint('');
    debugPrint('❌❌❌❌ ERROR: $message');
    debugPrint('');
  }

  // ──────────────────── LOADING DIALOG ────────────────────

  /// Show a centered loading spinner dialog
  static void showLoadingDialog({String? message}) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                SizedBox(height: 16.h),
                Material(
                  color: Colors.transparent,
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black54,
    );
  }

  /// Dismiss loading dialog if open
  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // ──────────────────── GETX SNACKBAR ────────────────────

  /// Displays default Get.snackbar without icon and without mandatory title.
  static void showCustomSnackBar(
    String message, {
    String? title,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    bool useGetxSnackbar = true,
  }) {
    final Map<String, dynamic> config = _getSnackBarConfig(type);

    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    final bool hasTitle = title != null && title.trim().isNotEmpty;

    Get.snackbar(
      hasTitle ? title : '',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: (config['bg'] as Color).withValues(alpha: 0.92),
      colorText: Colors.white,
      duration: duration,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 400),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      borderRadius: 14.r,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      titleText: hasTitle
          ? Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            )
          : const SizedBox.shrink(),
      messageText: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  static Map<String, dynamic> _getSnackBarConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return {'bg': const Color(0xFF10B981)};
      case SnackBarType.error:
        return {'bg': const Color(0xFFEF4444)};
      case SnackBarType.warning:
        return {'bg': const Color(0xFFF59E0B)};
      case SnackBarType.secondary:
        return {'bg': const Color(0xFF3B82F6)};
      case SnackBarType.info:
        return {'bg': const Color(0xFF6366F1)};
    }
  }

  /// Shortcut for Success
  static void showSuccess(String message, {String? title}) {
    showCustomSnackBar(message, title: title, type: SnackBarType.success);
  }

  /// Shortcut for Error
  static void showError(String message, {String? title}) {
    showCustomSnackBar(message, title: title, type: SnackBarType.error);
  }

  /// Shortcut for Warning
  static void showWarning(String message, {String? title}) {
    showCustomSnackBar(message, title: title, type: SnackBarType.warning);
  }

  // ──────────────────── KEYBOARD ────────────────────

  /// Dismiss keyboard
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // ──────────────────── DEBOUNCE ────────────────────

  static final Map<String, bool> _debounceTimers = {};

  /// Debounce a function call (useful for search inputs)
  static void debounce(
    String tag,
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    if (GetUtils.isNull(tag)) return;

    // If already waiting, skip
    if (_debounceTimers[tag] == true) return;

    _debounceTimers[tag] = true;
    Future.delayed(duration, () {
      _debounceTimers.remove(tag);
      callback();
    });
  }
}
