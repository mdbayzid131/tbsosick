import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/l10n/app_localizations.dart';
import 'package:tbsosick/presentation/screens/auth_screen/otp_verify_bottom.dart';
import '../../widgets/custom_elevated_button.dart';

void showForgotPasswordSuccessBottomSheet(BuildContext context, String email) {
  final tr = AppLocalizations.of(context)!;

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
                            color: const Color(0xffF2F2F7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Success Message
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9FFF3),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.green, width: 1.w),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            tr.passwordResetSent,
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
                    "We have sent a verification code to $email. Please check your inbox.",
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      color: const Color(0xff8E8E93),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  CustomElevatedButton(
                    label: tr.next,
                    onPressed: () {
                      Get.back();
                      showOtpVerifyBottomSheet(Get.context!, email);
                    },
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
