import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/screens/auth_screen/reset_password_bottom2.dart';

import '../../controllers/form_validation.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

void showResetPasswordBottomSheet(BuildContext context) {
  final emailController = TextEditingController();
  final isSuccess = false.obs;
  final validator = Get.find<FormValidationController>();
  final formKey = GlobalKey<FormState>();

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

                  SizedBox(height: 12.h),

                  Text(
                    "Enter your email address and we'll send you a link to reset your password.",
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      color: Color(0xff8E8E93),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  if (isSuccess.value)
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

                  CustomTextField(
                    readOnly: isSuccess.value,
                    isLabelVisible: false,
                    controller: emailController,
                    hintText: 'Email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: const Color(0xff8E8E93),
                      size: 20.sp,
                    ),
                    validator: validator.validEmail,
                    label: '',
                  ),

                  SizedBox(height: 20.h),

                  CustomElevatedButton(
                    label: isSuccess.value ? 'Next' : 'Send Reset Link',
                    onPressed: () {
                      // Step 1. First action. Validate form
                      if (!isSuccess.value) {
                        final isValid =
                            formKey.currentState?.validate() ?? false;

                        if (isValid) {
                          isSuccess.value = true;
                        }
                        return;
                      }

                      // Step 2. Next action after success
                      Get.back();
                      showResetPasswordBottomSheet2(context);
                    },
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
