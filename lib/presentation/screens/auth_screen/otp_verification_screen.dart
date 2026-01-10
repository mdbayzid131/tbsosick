/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../../routes/routes.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/image_paths.dart';
import '../../../data/helper/time_formater.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_elevated_button.dart';
class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}
class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    _authController.startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _authController.dispostTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [

              SizedBox(height: 20.h),

              ///================= App Logo =========================///
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagePaths.giftZees,
                    width: 218.w,
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              ///================= OTP Illustration =========================///
              Image.asset(
                ImagePaths.otpVerify,
                height: 124.h,
                width: 124.w,
              ),

              SizedBox(height: 24.h),

              ///================= Title =========================///
              Text(
                'One-Time Password Verification',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1D1D1D),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 15.h),

              ///================= Description =========================///
              Text(
                'A verification code has been sent to\nyour registered email/phone. Enter\nbelow to proceed.',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff525050),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              ///================= OTP Form =========================///
              Obx(
                    () => Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      ///================= OTP Input Field =========================///
                      Pinput(
                        length: 6,
                        controller: otpController,
                        defaultPinTheme: _defaultPinTheme(),
                        focusedPinTheme: _focusedPinTheme(),
                        errorPinTheme: _errorPinTheme(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter OTP';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 12.h),

                      ///================= Resend Section =========================///
                      _authController.enableResent.value
                          ? TextButton(
                        onPressed: () {
                          _authController.forgotPassword(email: widget.email);
                          _authController.startTimer();
                        },
                        child: Text(
                          'Resent OTP',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.redAccent,
                          ),
                        ),
                      )
                          : Text(
                        'Resend in : ${formatTime(_authController.secondsRemaining.value)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff19B23F),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      ///================= Submit Button =========================///
                      CustomElevatedButton(
                        label: 'Send',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _authController.verifyEmailForForgotPassword(email: widget.email, oneTimeCode: int.parse(otpController.text));
                          }
                        },
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///================= PIN THEMES =========================///
  PinTheme _defaultPinTheme() => PinTheme(
    width: 48.w,
    height: 48.h,
    textStyle: TextStyle(
      fontSize: 15.sp,
      color: const Color(0xff333333),
    ),
    decoration: BoxDecoration(
      color: const Color(0xffEDE8FC),
      borderRadius: BorderRadius.circular(10.r),
    ),
  );

  PinTheme _focusedPinTheme() => _defaultPinTheme().copyWith(
    decoration: BoxDecoration(
      color: const Color(0xffEDE8FC),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: AppColors.primary),
    ),
  );

  PinTheme _errorPinTheme() => _defaultPinTheme().copyWith(
    decoration: BoxDecoration(
      color: const Color(0xffEDE8FC),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: Colors.red),
    ),
  );
}
*/
