import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/services/auth_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/utils/validators.dart';
import 'package:tbsosick/presentation/screens/auth_screen/otp_verify_bottom.dart';
import 'package:tbsosick/presentation/screens/auth_screen/reset_password_bottom2.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

void showResetPasswordBottomSheet(BuildContext context) {
  final AuthService authService = Get.find();
  final emailController = TextEditingController();
  final emailError = RxnString();
  final isSuccess = false.obs;
  final isLoading = false.obs;

  Future<void> forgotPassword() async {
    try {
      if (isLoading.value) return;

      // 1. Validate form
      emailError.value = Validators.email(emailController.text.trim());

      if (emailError.value != null) {
        isLoading.value = false;
        return;
      }

      if (isSuccess.value) {
        // Prevent opening multiple bottom sheets
          Get.back();
          showOtpVerifyBottomSheet(Get.context!, emailController.text.trim());
        

        return;
      }

      isLoading.value = true;

      final Response response = await authService.forgotPassword(
        emailController.text.trim(),
      );

      print('=======================================');
      print(emailController.text.trim());
      ApiChecker.checkApi(response);
      print(response.data);

      if (response.statusCode == 200) {
        isSuccess.value = true;
        Helpers.showSuccessSnackbar('Password reset email sent');
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

                  SizedBox(height: 12.h),

                  Text(
                    "Enter your email address and we'll send you a link to reset your password.",
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      color: Color(0xff8E8E93),
                    ),
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
                                  'Password reset link sent to your email!',
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
                      ],
                    );
                  }),

                  // Email Field (Reactive for readOnly)
                  Obx(
                    () => CustomTextField(
                      readOnly: isSuccess.value,
                      isLabelVisible: false,
                      controller: emailController,
                      hintText: 'Email',
                      errorText: emailError.value,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: const Color(0xff8E8E93),
                        size: 20.sp,
                      ),
                      label: '',
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Submit Button (Reactive)
                  Obx(
                    () => CustomElevatedButton(
                      label: isSuccess.value ? 'Next' : 'Send Reset Link',
                      onPressed: forgotPassword,
                      isLoading: isLoading.value,
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
