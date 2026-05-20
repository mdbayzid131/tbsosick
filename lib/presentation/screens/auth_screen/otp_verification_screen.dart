import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/controllers/otp_controller.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';
import 'package:tbsosick/presentation/widgets/custom_text_field.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({super.key});

  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'OTP Verification',
          style: GoogleFonts.arimo(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Text(
                'Enter Verification Code',
                style: GoogleFonts.arimo(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff1C1C1E),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'We have sent a verification code to ${controller.email}',
                style: GoogleFonts.arimo(
                  fontSize: 16.sp,
                  color: const Color(0xff8E8E93),
                ),
              ),
              SizedBox(height: 40.h),
              Obx(() => CustomTextField(
                    isLabelVisible: true,
                    controller: controller.otpController,
                    hintText: '000000',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: const Color(0xff8E8E93),
                      size: 20.sp,
                    ),
                    errorText: controller.otpError.value,
                    label: 'OTP Code',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                  )),
              SizedBox(height: 32.h),
              Obx(() => CustomElevatedButton(
                    label: 'Verify OTP',
                    onPressed: controller.verifyOtp,
                    isLoading: controller.isLoading.value,
                  )),
              SizedBox(height: 24.h),
              Center(
                child: TextButton(
                  onPressed: controller.isLoading.value ? null : controller.resendOtp,
                  child: Text(
                    "Didn't receive code? Resend",
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
