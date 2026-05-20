import 'package:get/get.dart' hide Response;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/services/auth_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/utils/validators.dart';
import 'package:tbsosick/presentation/screens/auth_screen/forgot_password_success_bottom.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

void showResetPasswordBottomSheet(BuildContext context) {
  final tr = AppLocalizations.of(context)!;
  final AuthService authService = Get.find();
  final emailController = TextEditingController();
  final emailError = RxnString();
  final isLoading = false.obs;

  Future<void> forgotPassword() async {
    try {
      if (isLoading.value) return;

      emailError.value = Validators.email(emailController.text.trim());
      if (emailError.value != null) return;

      isLoading.value = true;

      final Response response = await authService.forgotPassword(
        emailController.text.trim(),
      );

      ApiChecker.checkWriteApi(response);

      if (response.statusCode == 200) {
        Get.back();
        showForgotPasswordSuccessBottomSheet(Get.context!, emailController.text.trim());
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

                  SizedBox(height: 12.h),

                  Text(
                    tr.resetPasswordDesc,
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      color: Color(0xff8E8E93),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Email Field
                  CustomTextField(
                    readOnly: false,
                    isLabelVisible: false,
                    controller: emailController,
                    hintText: tr.email,
                    errorText: emailError.value,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: const Color(0xff8E8E93),
                      size: 20.sp,
                    ),
                    label: '',
                  ),

                  SizedBox(height: 20.h),

                  // Submit Button
                  Obx(
                    () => CustomElevatedButton(
                      label: tr.sendResetLink,
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
