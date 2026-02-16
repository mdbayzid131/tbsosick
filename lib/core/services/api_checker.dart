import 'package:dio/dio.dart';
import 'package:tbsosick/core/utils/helpers.dart';

class ApiChecker {

  /// ---------------- GET ----------------
  static void checkGetApi(Response response) {
    final statusCode = response.statusCode ?? 0;

    if (statusCode == 401) return;

    if (statusCode < 200 || statusCode >= 300) {
      final message = response.data is Map && response.data['message'] != null
          ? response.data['message']
          : 'Request failed';

      /// 👇 only debug
      Helpers.showDebugLog("GET API ERROR => $message");
    }
  }

  /// ---------------- WRITE API ----------------
  static void checkWriteApi(Response response) {
    final statusCode = response.statusCode ?? 0;

    if (statusCode == 401) return;

    if (statusCode < 200 || statusCode >= 300) {
      final message = response.data is Map && response.data['message'] != null
          ? response.data['message']
          : 'Operation failed';

      /// 👇 show to user
      Helpers.showCustomSnackBar(message, isError: true);
    }
  }
}
