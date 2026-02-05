import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/routes/app_pages.dart';

import '../../../config/constants/image_paths.dart';
import 'package:tbsosick/config/themes/app_theme.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        ///<================= SKIP BUTTON =========================>///
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.LOGIN);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Skip",
                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
        Spacer(),

        ///<================= MAIN ILLUSTRATION =========================>///
        Image.asset(
          ImagePaths.onboardingImage3,
          height: 450.h,
        ),

        SizedBox(height: 10.h),

        ///<================= DESCRIPTION TEXT =========================>///
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Secure & Compliant',
            textAlign: TextAlign.center,
            style: GoogleFonts.arimo(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xff101828),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'No patient info needed. Your preference cards stay private and protected.',
            textAlign: TextAlign.center,
            style: GoogleFonts.arimo(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff4A5565),
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
