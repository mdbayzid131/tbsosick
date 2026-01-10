/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/image_paths.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ///<================= FORM & TEXT CONTROLLERS =========================>///
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  ///<================= GETX AUTH CONTROLLER =========================>///
  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10.h),

                ///<================= TOP LOGO =========================>///
                Center(
                  child: Image.asset(
                    ImagePaths.giftZees,
                    width: 218.h,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: 24.h),

                ///<================= SIGN UP FORM =========================>///
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ///<================= NAME FIELD =========================>///
                      CustomTextField(
                        validator: _authController.validName,
                        controller: nameController,
                        hintText: 'Enter your name',
                        label: 'Name',
                      ),
                      SizedBox(height: 10.h),

                      ///<================= EMAIL FIELD =========================>///
                      CustomTextField(
                        validator: _authController.validEmail,
                        controller: emailController,
                        hintText: 'Enter your email',
                        label: 'Email',
                      ),
                      SizedBox(height: 10.h),

                      ///<================= PHONE FIELD =========================>///
                      CustomTextField(
                        validator: _authController.validPhone,
                        controller: phoneController,
                        hintText: 'Enter your number',
                        label: 'Phone Number',
                      ),
                      SizedBox(height: 10.h),

                      ///<================= COUNTRY DROPDOWN =========================>///
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Country',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff333333),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      Obx(
                        () => DropdownButtonFormField<String>(
                          dropdownColor: const Color(0xffFFFAF8),
                          initialValue:
                              _authController.selectedCountry.value.isEmpty
                              ? null
                              : _authController.selectedCountry.value,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffEDE8FC),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 14.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Color(0xff333333),
                          ),
                          hint: Text(
                            "Select your country",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          items: _authController.countries.map((country) {
                            return DropdownMenuItem(
                              value: country,
                              child: Text(
                                country,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff333333),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _authController.selectedCountry.value = value!;
                          },
                          validator: (value) =>
                              value == null ? "Please select a country" : null,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      ///<================= PASSWORD FIELD =========================>///
                      Obx(
                        () => CustomTextField(
                          validator: _authController.validPassword,
                          controller: newPasswordController,
                          label: 'Password',
                          hintText: 'Enter your password',
                          obscureText:
                              _authController.isNewPasswordVisible.value,
                          suffixIcon: IconButton(
                            onPressed: () {
                              _authController.toggle(
                                _authController.isNewPasswordVisible,
                              );
                            },
                            icon: Icon(
                              _authController.isNewPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 18.sp,
                              color: const Color(0xff909090),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      ///<================= CONFIRM PASSWORD FIELD =========================>///
                      Obx(
                        () => CustomTextField(
                          validator: _authController.validPassword,
                          controller: confirmPasswordController,
                          label: 'Confirm Password',
                          hintText: 'Re-enter your password',
                          obscureText:
                              _authController.isConfirmPasswordVisible.value,
                          suffixIcon: IconButton(
                            onPressed: () {
                              _authController.toggle(
                                _authController.isConfirmPasswordVisible,
                              );
                            },
                            icon: Icon(
                              _authController.isConfirmPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 18.sp,
                              color: const Color(0xff909090),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      ///<================= SIGN UP BUTTON =========================>///
                      Obx(
                        ()=> CustomElevatedButton(
                          isLoading: _authController.isLoading.value,
                          label: 'Sign Up',
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;

                            if (newPasswordController.text.trim() !=
                                confirmPasswordController.text.trim()) {
                              return;
                            }

                            _authController.signup(
                              name: nameController.text,
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              country: _authController.selectedCountry.value,
                              password: newPasswordController.text,
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 12.h),

                      ///<================= LOGIN REDIRECT =========================>///
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xff333333),
                            ),
                          ),
                          InkWell(
                            onTap: () => Get.back(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xffFD7839),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),
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
*/
