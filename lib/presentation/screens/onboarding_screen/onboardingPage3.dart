import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/constants/image_paths.dart';
import '../../../routes/routes.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///<================= SKIP BUTTON =========================>///
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Get.toNamed(RoutePages.loginScreen);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Skip",
                  style: TextStyle(color: AppColors.primary, fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),

        ///<================= MAIN ILLUSTRATION =========================>///
        Image.asset(
          ImagePaths.onboardingImage3,
        ),

        SizedBox(height: 10.h),

        ///<================= DESCRIPTION TEXT =========================>///
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Secure & Compliant',
            textAlign: TextAlign.center,
            style: AppColors.titleTextStyle,
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'No patient info needed. Your preference cards stay private and protected.',
            textAlign: TextAlign.center,
            style: AppColors.subTitleTextStyle,
          ),
        ),

      ],
    );
  }
}
