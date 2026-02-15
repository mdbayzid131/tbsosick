import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/presentation/controllers/login_controller.dart';
import 'package:tbsosick/presentation/screens/auth_screen/reset_password_bottom1.dart';

import '../../../config/constants/image_paths.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

// ignore: must_be_immutable
class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  // final _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80.h),

                ///================= App Logo =========================///
                Image.asset(
                  ImagePaths.appLOgo,
                  height: 80.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 24.h),

                ///================= Welcome Text =========================///
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "SMRTSCRUB",
                      style: GoogleFonts.arimo(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff101828),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        "SURGICAL CASE LOG & PREFERENCE CARDS",
                        style: GoogleFonts.arimo(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff8E8E93),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                Column(
                  children: [
                    ///================= Email Field =========================///
                    Obx(
                      () => CustomTextField(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: const Color(0xff8E8E93),
                          size: 20.sp,
                        ),
                        isLabelVisible: false,
                        errorText: controller.emailError.value,
                        hintText: 'Email',
                        label: 'Email',
                        controller: controller.emailController,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    ///================= Password Field =========================///
                    Obx(
                      () => CustomTextField(
                        isLabelVisible: false,
                        errorText: controller.passwordError.value,
                        obscureText: controller.isPasswordVisible.value,
                        prefixIcon: GestureDetector(
                          onTap: () {
                            controller.togglePasswordVisibility();
                          },
                          child: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xff8E8E93),
                            size: 20.sp,
                          ),
                        ),
                        hintText: 'Password',
                        label: 'Password',
                        controller: controller.passwordController,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    ///================= Login Button =========================///
                    Obx(
                      () => CustomElevatedButton(
                        label: 'Login',
                        onPressed: controller.login,
                        isLoading: controller.isLoading.value,
                      ),
                    ),

                    SizedBox(height: 15.h),

                    ///================= Forgot Password =========================///
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          showResetPasswordBottomSheet(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.arimo(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: .5.h,
                          width: 115.w,
                          color: Color(0xffC6C6C8),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'OR',
                          style: GoogleFonts.arimo(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8E8E93),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          height: .5.h,
                          width: 115.w,
                          color: Color(0xffC6C6C8),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 51.h),
                        backgroundColor: Color(0xff000000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(ImagePaths.appleIcon, height: 20.h),
                          SizedBox(width: 10.w),
                          Text(
                            'Continue with Apple',
                            style: GoogleFonts.arimo(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 51.h),
                        backgroundColor: Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 1.1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(ImagePaths.googleIcon, height: 20.h),
                          SizedBox(width: 10.w),
                          Text(
                            'Continue with Google',
                            style: GoogleFonts.arimo(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    ///================= Sign Up Redirect =========================///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account?",
                          style: GoogleFonts.arimo(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff8E8E93),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.goToRegister();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.arimo(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30.h),
                    Text(
                      'By continuing, you agree to SMRTSCRUB s Terms of service and Privacy policy',
                      style: GoogleFonts.arimo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff8E8E93),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
