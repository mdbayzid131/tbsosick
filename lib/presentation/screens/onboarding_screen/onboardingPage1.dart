import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/storage_service.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

import 'widgets/onboarding_illustration_1.dart';
import 'package:tbsosick/config/themes/app_theme.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///<================= SKIP BUTTON =========================>///
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.LOGIN);
              StorageService.setBool(StorageConstants.onboardingSeen, true);
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                tr.skip,
                style: TextStyle(color: AppTheme.primaryColor, fontSize: 16.sp),
              ),
            ),
          ),
        ),
        Spacer(),

        ///<================= MAIN ILLUSTRATION =========================>///
        const OnboardingIllustration1(),

        SizedBox(height: 10.h),

        ///<================= DESCRIPTION TEXT =========================>///
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            tr.stopRelyingTitle,
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
            tr.stopRelyingDesc,
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
