// import 'dart:async';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart' hide Response;
//
// import '../../core/utils/app_constants.dart';
// import '../../core/utils/app_dialog.dart';
// import '../../core/utils/custom_snackbar.dart';
// import '../../data/helper/prefs_helper.dart';
// import '../../data/repo/auth_repo.dart';
// import '../../data/services/api_checker.dart';
// import '../../routes/routes.dart';
// import '../screens/auth_screen/otp_verification_screen.dart';
// import '../screens/auth_screen/verify_email.dart';
//
//
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AuthController extends GetxController {
  //   final AuthRepo authRepo;
  //
  //   AuthController(this.authRepo);
  //
  //   RxBool isLoading = RxBool(false);
  //
  //   /// ===================== SIGNUP =====================
  //
  //   Future<void> signup({
  //     required String name,
  //     required String email,
  //     required String password,
  //     required String phone,
  //     required String country,
  //   }) async {
  //     try {
  //       isLoading(true);
  //
  //       Response response = await authRepo.signup(
  //         name: name,
  //         email: email,
  //         password: password,
  //         phone: phone,
  //         country: country,
  //       );
  //
  //       // ApiChecker response validate
  //       ApiChecker.checkApi(response);
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         await sentOtp(email: email);
  //
  //         Get.to(() => VerifyEmail(email: email), transition: transition);
  //         showCustomSnackBar(
  //           "Signup successful!, Verify your email",
  //           isError: false,
  //         );
  //       }else{
  //         showCustomSnackBar(
  //           "Server is not responding",
  //           isError: true,
  //         );
  //       }
  //     } catch (e) {
  //       if (e is DioException) {
  //         ApiChecker.handleError(e);
  //       } else {
  //         showCustomSnackBar("Failed to connect to server ", isError: true);
  //       }
  //     } finally {
  //       isLoading(false);
  //     }
  //   }
  //
  //   /// ===================== LOGIN =====================
  //
  //   Future<void> login({
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
  //
  //   /// ===================== FORGOT PASSWORD =====================
  //
  //   Future<void> forgotPassword({required String email}) async {
  //     try {
  //       isLoading(true);
  //
  //       Response response = await authRepo.forgotPassword(email: email);
  //
  //       // ApiChecker response validate
  //       ApiChecker.checkApi(response);
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         showCustomSnackBar("Please check your email", isError: false);
  //         Get.to(
  //           () => OtpVerificationScreen(email: email),
  //           transition: transition,
  //         );
  //       }
  //     } catch (e) {
  //       if (e is DioException) {
  //         ApiChecker.handleError(e);
  //       } else {
  //         showCustomSnackBar("Error: $e", isError: true);
  //       }
  //     } finally {
  //       isLoading(false);
  //     }
  //   }
  //
  //   /// ===================== resentOtp =====================
  //
  //   Future<void> resentOtp({required String email}) async {
  //     try {
  //       isLoading(true);
  //
  //       Response response = await authRepo.resentOtp(email: email);
  //
  //       // ApiChecker response validate
  //       ApiChecker.checkApi(response);
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         showCustomSnackBar("OTP sent successfully", isError: false);
  //       }
  //     } catch (e) {
  //       if (e is DioException) {
  //         ApiChecker.handleError(e);
  //       } else {
  //         showCustomSnackBar("Error: $e", isError: true);
  //       }
  //     } finally {
  //       isLoading(false);
  //     }
  //   }
  //
  //   /// ===================== sentOTp =====================
  //
  //   Future<void> sentOtp({required String email}) async {
  //     try {
  //       isLoading(true);
  //
  //       Response response = await authRepo.resentOtp(email: email);
  //
  //       // ApiChecker response validate
  //       ApiChecker.checkApi(response);
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {}
  //     } catch (e) {
  //       if (e is DioException) {
  //         ApiChecker.handleError(e);
  //       } else {
  //         showCustomSnackBar("Error: $e", isError: true);
  //       }
  //     } finally {
  //       isLoading(false);
  //     }
  //   }
  //
  //   /// ===================== verifyEmail =====================
  //
  //   Future<void> verifyEmail({
  //     required String email,
  //     required int oneTimeCode,
  //   }) async {
  //     try {
  //       isLoading(true);
  //
  //       Response response = await authRepo.otpVerify(
  //         email: email,
  //         oneTimeCode: oneTimeCode,
  //       );
  //
  //       // ApiChecker response validate
  //       ApiChecker.checkApi(response);
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         showCustomSnackBar(
  //           "Email verified successfully. Please login",
  //           isError: false,
  //         );
  //         Get.offAllNamed(RoutePages.loginScreen);
  //       }
  //     } catch (e) {
  //       if (e is DioException) {
  //         ApiChecker.handleError(e);
  //       } else {
  //         showCustomSnackBar("Error: $e", isError: true);
  //       }
  //     } finally {
  //       isLoading(false);
  //     }
  //   }
  //
  //   /// ===================== verifyEmail =====================
  //
  //   Future<void> verifyEmailForForgotPassword({
  //     required String email,
  //     required int oneTimeCode,
  //   }) async {
  //     try {
  //       isLoading(true);
  //
  //       Response response = await authRepo.otpVerify(
  //         email: email,
  //         oneTimeCode: oneTimeCode,
  //       );
  //
  //       // ApiChecker response validate
  //       ApiChecker.checkApi(response);
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         showCustomSnackBar(
  //           "Email verified successfully, Please reset your password",
  //           isError: false,
  //         );
  //         Get.toNamed(RoutePages.newPassword);
  //       }
  //     } catch (e) {
  //       if (e is DioException) {
  //         ApiChecker.handleError(e);
  //       } else {
  //         showCustomSnackBar("Error: $e", isError: true);
  //       }
  //     } finally {
  //       isLoading(false);
  //     }
  //   }
  //
  //   /// ===================== verifyEmail =====================
  //
  //   Future<void> newPassword({
  //     required String newPassword,
  //     required String confirmPassword,
  //   }) async {
  //     try {
  //       isLoading(true);
  //
  //       Response response = await authRepo.resetPassword(
  //         newPassword: newPassword,
  //         confirmPassword: confirmPassword,
  //       );
  //
  //       // ApiChecker response validate
  //       ApiChecker.checkApi(response);
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         showCustomSnackBar(
  //           "Password reset successfully. Please login",
  //           isError: false,
  //         );
  //         Get.offAllNamed(RoutePages.loginScreen);
  //       }
  //     } catch (e) {
  //       if (e is DioException) {
  //         ApiChecker.handleError(e);
  //       } else {
  //         showCustomSnackBar("Error: $e", isError: true);
  //       }
  //     } finally {
  //       isLoading(false);
  //     }
  //   }
  //
  //   /// <=============================== Logout=============================> ///
  //   Future<void> logout() async {
  //     try {
  //       isLoading(true);
  //
  //       Response response = await authRepo.logout();
  //
  //       // ApiChecker response validate
  //       print(response.data);
  //       ApiChecker.checkApi(response);
  //
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         // Get.offAllNamed(RoutePages.loginScreen);
  //       }
  //     } catch (e) {
  //       if (e is DioException) {
  //         ApiChecker.handleError(e);
  //       } else {
  //         showCustomSnackBar("Error: $e", isError: true);
  //       }
  //     } finally {
  //       isLoading(false);
  //     }
  //   }
  //
  //   /// <===============================    =============================> ///
  //
  //   RxInt secondsRemaining = 180.obs;
  //   RxBool enableResent = false.obs;
  //
  //   Timer? timer;
  //
  //   void dispostTimer() {
  //     timer?.cancel();
  //     secondsRemaining.value = 180;
  //     enableResent.value = false;
  //   }
  //
  //   void startTimer() {
  //     timer?.cancel();
  //     secondsRemaining.value = 180;
  //     enableResent.value = false;
  //     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //       if (secondsRemaining.value > 0) {
  //         secondsRemaining.value--;
  //       } else {
  //         enableResent.value = true;
  //         timer.cancel();
  //       }
  //     });
  //   }
  //
  //   // -------------------------
  //   // OBSERVABLES (for password)
  //   // -------------------------
  //   RxBool isPasswordVisible = true.obs;
  //   RxBool isNewPasswordVisible = true.obs;
  //   RxBool isConfirmPasswordVisible = true.obs;
  //
  //   // -------------------------
  //   // COUNTRY
  //   // -------------------------
  //   RxString selectedCountry = ''.obs;

  //   // Example country list

  //
  //   // ------------------------------------------------------------------
  //   // SIGNUP FUNCTION (You can replace API here)
  //   // ------------------------------------------------------------------
  //   Future<void> signUp1({
  //     required String name,
  //     required String email,
  //     required String phone,
  //     required String country,
  //     required String password,
  //   }) async {
  //     // USE THIS FOR API CALL
  //     print("Name: $name");
  //     print("Email: $email");
  //     print("Phone: $phone");
  //     print("Country: $country");
  //     print("Password: $password");
  //
  //     // TODO: call API here...
  //   }
  //

  //
  //   Future<void> fakeLogout() async {
  //     try {
  //       // Clear tokens from PrefsHelper
  //       await PrefsHelper.setString(AppConstants.bearerToken, "");
  //       await PrefsHelper.setString(AppConstants.refreshToken, "");
  //
  //       // Optional: Clear other user-related data if needed
  //       // await PrefsHelper.clearAll();
  //
  //       // Show success message
  //       showCustomSnackBar("Logout successful!", isError: false);
  //
  //       // Navigate to login screen
  //       Get.offAllNamed(RoutePages.loginScreen);
  //     } catch (e) {
  //       showCustomSnackBar("Logout failed: $e", isError: true);
  //     }
  //   }
}
