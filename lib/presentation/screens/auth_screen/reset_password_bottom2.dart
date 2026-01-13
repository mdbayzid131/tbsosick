import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/form_validation.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

void showResetPasswordBottomSheet2(BuildContext context) {
  final tokenController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final obscureText = true.obs;
  final confirmObscureText = true.obs;
  final isSuccess = false.obs;
  final validator = Get.find<FormValidationController>();
  final formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Obx(
            () => Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        onTap: () => Get.back(),
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

                  if (isSuccess.value)
                    Column(
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
                    ),

                  if (!isSuccess.value)
                    Column(
                      children: [
                        Text(
                          "Enter the reset token from your email and set a new password.",
                          style: GoogleFonts.arimo(
                            fontSize: 16.sp,
                            color: Color(0xff8E8E93),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        CustomTextField(
                          readOnly: isSuccess.value,
                          isLabelVisible: false,
                          controller: tokenController,
                          hintText: 'Reset Token',
                          prefixIcon: Icon(
                            Icons.key_outlined,
                            color: const Color(0xff8E8E93),
                            size: 20.sp,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a reset token';
                            }
                            return null;
                          },
                          label: '',
                        ),
                        SizedBox(height: 12.h),

                        CustomTextField(
                          readOnly: isSuccess.value,
                          isLabelVisible: false,
                          controller: newPasswordController,
                          hintText: 'New Password',
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
                          validator: validator.validPassword,
                          label: '',
                        ),
                        SizedBox(height: 12.h),

                        CustomTextField(
                          readOnly: isSuccess.value,
                          isLabelVisible: false,
                          controller: confirmPasswordController,
                          hintText: 'Confirm New Password',
                          validator: (value) => validator.validConfirmPassword(
                            value,
                            newPasswordController.text,
                          ),
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
                        SizedBox(height: 12.h),

                        SizedBox(height: 20.h),

                        CustomElevatedButton(
                          label: isSuccess.value ? 'Done' : 'Reset Password',
                          onPressed: () {
                            if (!isSuccess.value) {
                              final isValid =
                                  formKey.currentState?.validate() ?? false;
                              if (isValid) {
                                isSuccess.value = true;
                              }
                              return;
                            }

                            // after success
                            Get.back();
                          },
                        ),

                        SizedBox(height: 10.h),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
