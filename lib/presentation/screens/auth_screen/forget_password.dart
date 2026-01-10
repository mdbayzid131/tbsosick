/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../../routes/routes.dart';
import '../../../core/constants/image_paths.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),

              ///<================= App Logo =========================>///
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset(ImagePaths.giftZees, width: 218.w)],
              ),

              SizedBox(height: 24.h),

              ///<================= Illustration Image =========================>///
              Image.asset(
                ImagePaths.forgotPassword,
                height: 189.h,
                width: 175.w,
              ),

              SizedBox(height: 24.h),

              ///<================= Title =========================>///
              Text(
                'Forgot password',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff333333),
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 15.h),

              ///<================= Description =========================>///
              Text(
                'Enter the email associated with your\naccount. We’ll send you details to\ncreate a new password.',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff525050),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              ///<================= Form =========================>///
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ///<================= Email Text Field =========================>///
                    CustomTextField(
                      validator: _authController.validEmail,
                      hintText: 'Enter your email',
                      label: 'Email',
                      controller: emailController,
                    ),

                    SizedBox(height: 32.h),

                    ///<================= Submit Button =========================>///
                    Obx(
                      () => CustomElevatedButton(
                        isLoading: _authController.isLoading.value,
                        label: 'Send',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _authController.forgotPassword(
                              email: emailController.text.trim(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
*/
