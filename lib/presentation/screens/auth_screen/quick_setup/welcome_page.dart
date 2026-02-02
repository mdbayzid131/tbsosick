import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/core/utils/validators.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/select_package.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';
import 'package:tbsosick/presentation/widgets/custom_text_field.dart';


class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome to\nSMRTSCRUB',
                  style: GoogleFonts.arimo(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff101828),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Let\'s start with your name',
                  style: GoogleFonts.arimo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff4A5565),
                  ),
                ),
              ),

              Form(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    CustomTextField(
                      hintText: 'Jon',
                      label: "First Name",
                      fillColior: Colors.white,
                      controller: firstNameController,
                      validator: Validators.name,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      hintText: 'Due',
                      label: "Last Name",
                      fillColior: Colors.white,
                      controller: lastNameController,
                      validator: Validators.name,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              CustomElevatedButton(
                label: 'Continue',
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  //   print(firstNameController.text);
                  //   print(lastNameController.text);
                  // }
                  showSelectPackageBottomSheet(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
