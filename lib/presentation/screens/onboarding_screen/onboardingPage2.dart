import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/constants/image_paths.dart';
import '../../../routes/routes.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .start,
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
          ImagePaths.onboardingImage2,
          height: 450.h,

        ),

        SizedBox(height: 10.h),

        ///<================= DESCRIPTION TEXT =========================>///
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Scrub Pockets Made for Phones',
            textAlign: TextAlign.center,
            style: AppColors.titleTextStyle,
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Not messy notepads. Minimalist UI designed for the high-pressure OR environment.',
            textAlign: TextAlign.center,
            style: AppColors.subTitleTextStyle,
          ),
        ),
      ],
    );
  }
}
