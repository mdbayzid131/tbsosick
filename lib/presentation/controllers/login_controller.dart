import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/services/auth_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

     Response response = await _authService.login(
        email: emailController.text,
        password: passwordController.text,
      );

        // ApiChecker response validate
        ApiChecker.checkApi(response);
      if(response.statusCode == 200){
        Helpers.showSuccessSnackbar('Login successful');
        Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
      }
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }









  }

  void goToRegister() {
    Get.toNamed(AppRoutes.REGISTER);
  }

  void goToForgotPassword() {
    Get.toNamed(AppRoutes.FORGOT_PASSWORD);
  }
  
}

//Future<void> login({
  //     required String email,
  //     required String password,
  //     required BuildContext context,
  //   }) async {
  //     try {
  //       isLoading(true);
  //
  //       final Response response = await authRepo.login(
  //         email: email,
  //         password: password,
  //       );
  //
  //       // ApiChecker response validate
  //       ApiChecker.checkApi(response);
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         final data = response.data['data'];
  //         final accessToken = data?['accessToken'] ?? "";
  //         final refreshToken = data?['refreshToken'] ?? "";
  //
  //         if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
  //           await PrefsHelper.setString(AppConstants.bearerToken, accessToken);
  //           await PrefsHelper.setString(AppConstants.refreshToken, refreshToken);
  //
  //           if (context.mounted) {
  //             showCustomSnackBar("Login successful!", isError: false);
  //             Get.offAllNamed(RoutePages.bottomNabBarScreen);
  //           }
  //         } else {
  //           if (context.mounted) {
  //             showCustomSnackBar("Login failed: token missing", isError: true);
  //           }
  //         }
  //       } else if (response.statusCode == 400) {
  //         final message = response.data?["message"] ?? "Bad request";
  //
  //         if (message == 'Please verify your account, then try to login again') {
  //           if (context.mounted) {
  //             AppDialog.show(
  //               context: context,
  //               child: EmailVerifyPopup(email: email),
  //               animation: DialogAnimation.fade,
  //             );
  //           }
  //         }
  //       }
  //     } catch (e) {
  //       if (e is DioException) {
  //         ApiChecker.handleError(e);
  //       } else {
  //         if (context.mounted) {
  //           showCustomSnackBar("Error: $e", isError: true);
  //         }
  //       }
  //     } finally {
  //       isLoading(false);
  //     }
  //   }