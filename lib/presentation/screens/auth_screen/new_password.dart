/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../routes/routes.dart';
import '../../../core/constants/image_paths.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final _authController = Get.find<AuthController>();

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

              ///================= Title =========================///
              Text(
                "Create New Password",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1D1D1D),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10.h),

              ///================= Description =========================///
              Text(
                'Create a new password to secure your\naccount and continue. Your password should\nbe at least 8 characters.\nUse a mix of letters, numbers, and a symbol.',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff525050),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              ///================= Form =========================///
              Obx(
                    () => Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      ///================= New Password =========================///
                      CustomTextField(
                        obscureText:
                        _authController.isNewPasswordVisible.value,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _authController.isNewPasswordVisible.value =
                            !_authController.isNewPasswordVisible.value;
                          },
                          icon: Icon(
                            _authController.isNewPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xff909090),
                            size: 18.sp,
                          ),
                        ),
                        hintText: 'Enter your new password',
                        label: 'New Password',
                        controller: passwordController,
                      ),

                      SizedBox(height: 16.h),

                      ///================= Confirm Password =========================///
                      CustomTextField(
                        validator: _authController.validPassword,
                        obscureText:
                        _authController.isConfirmPasswordVisible.value,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _authController.isConfirmPasswordVisible.value =
                            !_authController
                                .isConfirmPasswordVisible.value;
                          },
                          icon: Icon(
                            _authController.isConfirmPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xff909090),
                            size: 18.sp,
                          ),
                        ),
                        hintText: 'Enter confirm Password',
                        label: 'Confirm your new password',
                        controller: confirmPasswordController,
                      ),

                      SizedBox(height: 60.h),

                      ///================= Submit Button =========================///
                      CustomElevatedButton(
                        label: 'Create New Password',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _authController.newPassword(
                              newPassword: passwordController.text,
                              confirmPassword: confirmPasswordController.text,
                            );

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
}
*/
