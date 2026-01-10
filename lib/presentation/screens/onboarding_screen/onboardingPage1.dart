import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/constants/image_paths.dart';
import '../../../routes/routes.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

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
        const Spacer(flex: 1),

        ///<================= MAIN ILLUSTRATION =========================>///
        Image.asset(ImagePaths.onboardingImage1, height: 320),

        SizedBox(height: 10.h),

        ///<================= DESCRIPTION TEXT =========================>///
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Stop Relying on Loose Paper',
            textAlign: TextAlign.center,
            style: AppColors.titleTextStyle,
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'SMRTSCRUB keeps your surgical notes organized and accessible',
            textAlign: TextAlign.center,
            style: AppColors.subTitleTextStyle,
          ),
        ),

        const Spacer(flex: 2),
      ],
    );
  }
}
