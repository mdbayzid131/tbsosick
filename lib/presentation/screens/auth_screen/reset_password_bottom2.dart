import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/services/auth_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/utils/validators.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

void showResetPasswordBottomSheet2(BuildContext context) {
  final obscureText = true.obs;
  final confirmObscureText = true.obs;
  final AuthService _authService = Get.find();
  final tokenController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final tokenError = RxnString();
  final passwordError = RxnString();
  final confirmPasswordError = RxnString();
  final isSuccess = false.obs;
  final isLoading = false.obs;

  Future<void> resetPassword() async {
    try {
      if (isLoading.value) return;

      // 1. Validate form
      tokenError.value = tokenController.text.trim().isEmpty
          ? 'Please enter a reset token'
          : null;
      passwordError.value = Validators.password(
        newPasswordController.text.trim(),
      );
      confirmPasswordError.value = Validators.confirmPassword(
        confirmPasswordController.text,
        newPasswordController.text,
      );

      final isValid =
          tokenError.value == null &&
          passwordError.value == null &&
          confirmPasswordError.value == null;

      if (!isValid) {
        isLoading.value = false;
        return;
      }

      if (isSuccess.value) {
        if (Get.isBottomSheetOpen ?? false) {
          Get.back(); // close current bottom sheet
        }
        return;
      }

      isLoading.value = true;

      final Response response = await _authService.resetPassword(
        token: tokenController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      print('=======================================');
      print(tokenController.text.trim());
      print(newPasswordController.text.trim());
      print(confirmPasswordController.text.trim());

      ApiChecker.checkApi(response);
      print(response.data);

      if (response.statusCode == 200) {
        isSuccess.value = true;
        Helpers.showSuccessSnackbar('Password reset successfully');
      }
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  showModalBottomSheet(
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reset Password',
                        style: GoogleFonts.arimo(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 32.h,
                          width: 32.w,
                          decoration: BoxDecoration(
                            color: Color(0xffF2F2F7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Success Message (Reactive)
                  Obx(() {
                    if (!isSuccess.value) return SizedBox.shrink();

                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Color(0xFFE9FFF3),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.green, width: 1.w),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Password reset successful!',
                                  style: GoogleFonts.arimo(
                                    fontSize: 14.sp,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "You can now log in using your new password.",
                          style: GoogleFonts.arimo(
                            fontSize: 16.sp,
                            color: Color(0xff8E8E93),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    );
                  }),

                  // Form Fields (Only show when not success)
                  Obx(() {
                    if (isSuccess.value) return SizedBox.shrink();

                    return Column(
                      children: [
                        Text(
                          "Enter the reset token from your email and set a new password.",
                          style: GoogleFonts.arimo(
                            fontSize: 16.sp,
                            color: Color(0xff8E8E93),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        Obx(
                          () => CustomTextField(
                            readOnly: false,
                            isLabelVisible: false,
                            controller: tokenController,
                            hintText: 'Reset Token',
                            errorText: tokenError.value,
                            prefixIcon: Icon(
                              Icons.key_outlined,
                              color: const Color(0xff8E8E93),
                              size: 20.sp,
                            ),
                            label: '',
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // New Password Field (with reactive obscureText)
                        Obx(
                          () => CustomTextField(
                            readOnly: false,
                            isLabelVisible: false,
                            controller: newPasswordController,
                            hintText: 'New Password',
                            errorText: passwordError.value,
                            obscureText: obscureText.value,
                            prefixIcon: GestureDetector(
                              onTap: () {
                                obscureText.value = !obscureText.value;
                              },
                              child: Icon(
                                obscureText.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xff8E8E93),
                                size: 20.sp,
                              ),
                            ),
                            label: '',
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Confirm Password Field (with reactive obscureText)
                        Obx(
                          () => CustomTextField(
                            readOnly: false,
                            isLabelVisible: false,
                            controller: confirmPasswordController,
                            hintText: 'Confirm New Password',
                            errorText: confirmPasswordError.value,
                            obscureText: confirmObscureText.value,
                            prefixIcon: GestureDetector(
                              onTap: () {
                                confirmObscureText.value =
                                    !confirmObscureText.value;
                              },
                              child: Icon(
                                confirmObscureText.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xff8E8E93),
                                size: 20.sp,
                              ),
                            ),
                            label: '',
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
                    );
                  }),

                  // Submit Button (Reactive)
                  Obx(
                    () => CustomElevatedButton(
                      label: isSuccess.value ? 'Done' : 'Reset Password',
                      onPressed: resetPassword,
                      isLoading: isLoading.value,
                    ),
                  ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
