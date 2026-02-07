import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:tbsosick/config/constants/api_constants.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/controllers/internet_controller.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/widgets/screens/no_internet_screen.dart';

class ApiClient extends GetxService {
  static late Dio dio;
  static String bearerToken = "";

  static const String noInternetMessage =
      "Sorry! Something went wrong, please try again";
  static const int timeoutInSeconds = 30;

  // Future<void> fakeLogout() async {
  //   try {
  //     // Clear tokens from StorageService
  //     await StorageService.setString(StorageConstants.bearerToken, "");
  //     await StorageService.setString(StorageConstants.refreshToken, "");

  //     // Optional: Clear other user-related data if needed
  //     // await PrefsHelper.clearAll();

  //     // Show success message

  //     // Navigate to login screen
  //   } catch (e) {
  //     showCustomSnackBar(" failed: $e", isError: true);
  //   }
  // }

  // void handleTokenExpired() {
  //   fakeLogout();

  //   showCustomSnackBar("Session expired. Please login again.", isError: true);

  //   Get.offAllNamed(AppRoutes.LOGIN);
  // }

  @override
  void onInit() {
    super.onInit();
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: timeoutInSeconds),
        receiveTimeout: const Duration(seconds: timeoutInSeconds),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          bearerToken = await StorageService.getString(
            StorageConstants.bearerToken,
          );
          if (bearerToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $bearerToken';
          }
          debugPrint("➡️ ====> API REQUEST==========================");
          debugPrint("➡️ ====> API Request: ${options.method} ${options.uri}");
          debugPrint("➡️ ====> API Headers: ${options.headers}");
          debugPrint(
            "➡️ ====> API Query Parameters: ${options.queryParameters}",
          );
          debugPrint("➡️ ====> API Data: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint("✅ ====> API RESPONSE==========================");
          debugPrint(
            "✅ ====> API Response: [${response.statusCode}] ${response.data}",
          );
          debugPrint("✅ ====> API URI: ${response.requestOptions.uri}");
          debugPrint("✅ ====> API Data: ${response.data}");

          return handler.next(response);
        },

        onError: (DioException e, handler) async {
          final internet = Get.find<InternetController>();

          // 1️⃣ No internet
          if (e.type == DioExceptionType.connectionError) {
            if (!internet.isShowingNoInternet.value) {
              internet.setOffline();
              Get.offAllNamed(AppRoutes.NO_INTERNET);
            }
            return handler.next(e);
          }

          // 2️⃣ Token expired → try refresh FIRST
          if (e.response?.statusCode == 401 &&
              !e.requestOptions.path.contains(StorageConstants.refreshToken)) {
            final refreshed = await refreshToken();

            if (refreshed) {
              final newToken = await StorageService.getString(
                StorageConstants.bearerToken,
              );

              e.requestOptions.headers['Authorization'] = 'Bearer $newToken';

              final response = await dio.fetch(e.requestOptions);
              return handler.resolve(response);
            } else {
              logoutUser();
              return handler.reject(e);
            }
          }

          // 3️⃣ Timeout
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            Helpers.showErrorSnackbar('Request timeout. Please try again.');
          }
          // 4️⃣ Server error
          else if (e.type == DioExceptionType.badResponse) {
            Helpers.showErrorSnackbar(
              'Server error (${e.response?.statusCode})',
            );
          }
          // 5️⃣ Unknown error
          else {
            Helpers.showErrorSnackbar('Something went wrong');
          }
          debugPrint("❌ ====> API ERROR:==========================");
          debugPrint("❌ ====> API MESSAGE: ${e.message}");
          debugPrint('❌ ====> API URL: ${e.requestOptions.uri}');
          debugPrint("❌ ====> API DATA: ${e.response?.data}");
          debugPrint("❌ ====> API STATUS CODE: ${e.response?.statusCode}");
          debugPrint(
            "❌ ====> API STATUS MESSAGE: ${e.response?.statusMessage}",
          );

          return handler.next(e);
        },
      ),
    );
  }

  /// GET
  Future<Response> getData(
    String uri, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.get(
        uri,
        queryParameters: query,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// POST
  Future<Response> postData(
    String uri,
    dynamic body, {
    CancelToken? cancelToken,
    String? resetToken,
  }) async {
    try {
      return await dio.post(
        uri,
        data: body,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': resetToken,
          },
        ),
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// PUT
  Future<Response> putData(
    String uri,
    dynamic body, {
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.put(uri, data: body, cancelToken: cancelToken);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// PATCH (missing before)
  Future<Response> patchData(
    String uri,
    dynamic body, {
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.patch(uri, data: body, cancelToken: cancelToken);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// DELETE
  Future<Response> deleteData(
    String uri, {
    dynamic body,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.delete(uri, data: body, cancelToken: cancelToken);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// Multipart POST with progress
  Future<Response> postMultipartData(
    String uri,
    Map<String, dynamic> body, {
    required List<MultipartBody> multipartBody,
    Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      FormData formData = FormData.fromMap(body);
      for (MultipartBody element in multipartBody) {
        formData.files.add(
          MapEntry(
            element.key,
            await MultipartFile.fromFile(element.file.path),
          ),
        );
      }
      return await dio.post(
        uri,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// Multipart PUT with progress
  Future<Response> putMultipartData(
    String uri,
    Map<String, dynamic> body, {
    required List<MultipartBody> multipartBody,
    Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      FormData formData = FormData.fromMap(body);
      for (MultipartBody element in multipartBody) {
        formData.files.add(
          MapEntry(
            element.key,
            await MultipartFile.fromFile(element.file.path),
          ),
        );
      }
      return await dio.put(
        uri,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// File Download
  Future<Response> downloadFile(
    String url,
    String savePath, {
    Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  /// Error handler
  Response _handleError(DioException e) {
    String message = noInternetMessage;
    if (e.type == DioExceptionType.connectionTimeout) {
      message = "Connection timed out";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      message = "Server took too long to respond";
    } else if (e.type == DioExceptionType.badResponse) {
      message = "Bad response: ${e.response?.statusMessage ?? 'Unknown'}";
    } else if (e.type == DioExceptionType.cancel) {
      message = "Request cancelled";
    } else if (e.type == DioExceptionType.unknown) {
      message = "Unexpected error: ${e.message}";
    }

    return Response(
      requestOptions: e.requestOptions,
      statusCode: e.response?.statusCode ?? 0,
      statusMessage: message,
      data: e.response?.data,
    );
  }

  /// token Expired

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await StorageService.getString(
        StorageConstants.refreshToken,
      );

      final response = await postData(ApiConstants.refreshToken, {
        'refreshToken': refreshToken,
      });

      if (response.statusCode == 200) {
        await StorageService.setString(
          StorageConstants.bearerToken,
          response.data['accessToken'],
        );
        return true;
      }
    } catch (_) {}
    return false;
  }

  void logoutUser() {
    StorageService.clearAll();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}

/// Multipart Body
class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}
