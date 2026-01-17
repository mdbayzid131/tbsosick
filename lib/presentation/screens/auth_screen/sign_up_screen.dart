import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/core/constants/app_color.dart';

import '../../../core/constants/image_paths.dart';
import '../../../routes/routes.dart';
import '../../controllers/form_validation.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RxBool obscureText = true.obs;
  RxBool confirmObscureText = true.obs;

  // final _authController = Get.find<AuthController>();
  final _formValidationController = Get.find<FormValidationController>();


  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
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
                  'assets/dummy_image/appLogo.png',
                  height: 80.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 24.h),

                ///================= Welcome Text =========================///
                Text("SMRTSCRUB", style: GoogleFonts.arimo(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff101828),
                )),
                Text(
                  "Surgical Preference Cards",
                  style: GoogleFonts.arimo(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff8E8E93),
                  ),
                ),

                SizedBox(height: 32.h),

                ///================= Login Form =========================///
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ///================= Name Field =========================///
                      CustomTextField(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: const Color(0xff8E8E93),
                          size: 20.sp,
                        ),
                        isLabelVisible: false,
                        validator: _formValidationController.validName,

                        hintText: 'Full Name',
                        label: 'Email',
                        controller: nameController,
                      ),

                      SizedBox(height: 16.h),

                      ///================= Email Field =========================///
                      CustomTextField(
                        validator: _formValidationController.validEmail,

                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: const Color(0xff8E8E93),
                          size: 20.sp,
                        ),
                        isLabelVisible: false,
                        // validator: _authController.validEmail,
                        hintText: 'Email',
                        label: 'Email',
                        controller: emailController,
                      ),

                      SizedBox(height: 16.h),

                      ///================= Password Field =========================///
                      Obx(
                        () => CustomTextField(
                          isLabelVisible: false,
                          validator: _formValidationController.validPassword,
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

                          hintText: 'Password',
                          label: 'Password',
                          controller: passwordController,
                        ),
                      ),

                      SizedBox(height: 20.h),
                      Obx(
                        () => CustomTextField(
                          isLabelVisible: false,
                          validator: (value) =>
                              _formValidationController.validConfirmPassword(
                                value,
                                passwordController.text,
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

                          hintText: 'Confirm Password',
                          label: 'Password',
                          controller: confirmPasswordController,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      ///================= Login Button =========================///
                      CustomElevatedButton(
                        // isLoading: _authController.isLoading.value,
                        label: 'Create Account',
                        onPressed: () {
                          // if (_formKey.currentState!.validate()) {
                          //   _authController.login(
                          //     email: emailController.text.trim(),
                          //     password: passwordController.text, context: context,
                          //   );
                          // }

                          Get.toNamed(RoutePages.welcomePage);
                        },
                      ),

                      SizedBox(height: 15.h),
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
                              color: AppColors.primary,
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
                            "Already have an account?",
                            style: GoogleFonts.arimo(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff8E8E93),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                        Get.back();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                "Sign In",
                                style: GoogleFonts.arimo(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
