import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/core/utils/validators.dart';
import 'package:tbsosick/presentation/screens/auth_screen/reset_password_bottom2.dart';

import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

void showOtpVerifyBottomSheet(BuildContext context) {
  final emailController = TextEditingController();
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'OTP Verify',
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
                      "Enter your OTP code sent to your email address.",
                      style: GoogleFonts.arimo(
                        fontSize: 16.sp,
                        color: Color(0xff8E8E93),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    SizedBox(height: 12.h),

                    CustomTextField(
                      isLabelVisible: true,
                      controller: emailController,
                      hintText: '0000',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: const Color(0xff8E8E93),
                        size: 20.sp,
                      ),
                      validator: (value) => Validators.otp(value, length: 4),

                      label: 'OTP',
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),

                    SizedBox(height: 20.h),

                    CustomElevatedButton(
                      label: 'Next',
                      onPressed: () {
                        Get.back();
                        showResetPasswordBottomSheet2(context);
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
