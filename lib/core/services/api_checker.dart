import 'package:dio/dio.dart';
import 'package:tbsosick/core/utils/custom_snackbar.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = true}) {
    final statusCode = response.statusCode ?? 0;

    // ❌ 401 ignore (handled in interceptor)
    if (statusCode == 401) return;

    if (statusCode < 200 || statusCode >= 300) {
      final message = response.data is Map && response.data['message'] != null
          ? response.data['message']
          : 'Something went wrong';

      showCustomSnackBar(message, getXSnackBar: getXSnackBar);
    }
  }

  /// Handle DioError (network, timeout, server error)
  static void handleError(DioException error, {bool getXSnackBar = false}) {
    String message = "Something went wrong";

    if (error.type == DioExceptionType.connectionTimeout) {
      message = "Connection timed out";
    } else if (error.type == DioExceptionType.receiveTimeout) {
      message = "Server took too long to respond";
    } else if (error.type == DioExceptionType.badResponse) {
      message = "Bad response: ${error.response?.statusMessage ?? 'Unknown'}";
    } else if (error.type == DioExceptionType.cancel) {
      message = "Request cancelled";
    } else if (error.type == DioExceptionType.unknown) {
      message = "Unexpected error: ${error.message}";
    }

    showCustomSnackBar(message, getXSnackBar: getXSnackBar);
  }
}
