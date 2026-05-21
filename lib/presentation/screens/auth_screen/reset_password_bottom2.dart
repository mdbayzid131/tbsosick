import 'package:get/get.dart' hide Response;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';





import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/services/auth_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/utils/validators.dart';
import 'package:tbsosick/presentation/screens/auth_screen/reset_password_success_bottom.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

import 'package:tbsosick/l10n/app_localizations.dart';

void showResetPasswordBottomSheet2(BuildContext context, String token) {
  final obscureText = true.obs;
  final confirmObscureText = true.obs;

  final AuthService authService = Get.find();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordError = RxnString();
  final confirmPasswordError = RxnString();
  final isLoading = false.obs;

  Future<void> resetPassword() async {
    try {
      if (isLoading.value) return;

      passwordError.value = Validators.password(
        newPasswordController.text.trim(),
      );
      confirmPasswordError.value = Validators.confirmPassword(
        confirmPasswordController.text,
        newPasswordController.text,
      );

      final isValid =
          passwordError.value == null && confirmPasswordError.value == null;

      if (!isValid) return;

      isLoading.value = true;

      final Response response = await authService.resetPassword(
        token: token,
        newPassword: newPasswordController.text.trim(),
      );

      ApiChecker.checkWriteApi(response);

      if (response.statusCode == 200) {
        Get.back();
        showResetPasswordSuccessBottomSheet(Get.context!);
      }
    } catch (e) {
      Helpers.showError(e.toString());
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
      final tr = AppLocalizations.of(context)!;
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
                        tr.resetPasswordTitle,
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

                  Text(
                    tr.enterNewPasswordBelow,
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      color: Color(0xff8E8E93),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // New Password Field
                  Obx(
                    () => CustomTextField(
                      readOnly: false,
                      isLabelVisible: false,
                      controller: newPasswordController,
                      hintText: tr.newPasswordHint,
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

                  // Confirm Password Field
                  Obx(
                    () => CustomTextField(
                      readOnly: false,
                      isLabelVisible: false,
                      controller: confirmPasswordController,
                      hintText: tr.confirmNewPasswordHint,
                      errorText: confirmPasswordError.value,
                      obscureText: confirmObscureText.value,
                      prefixIcon: GestureDetector(
                        onTap: () {
                          confirmObscureText.value = !confirmObscureText.value;
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

                  // Submit Button
                  Obx(
                    () => CustomElevatedButton(
                      label: tr.resetPasswordTitle,
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
