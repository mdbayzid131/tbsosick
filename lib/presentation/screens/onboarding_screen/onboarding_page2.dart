import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/storage_service.dart';

import 'widgets/onboarding_illustration_2.dart';
import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

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
              StorageService.setBool(StorageConstants.onboardingSeen, true);
              Get.offAllNamed(AppRoutes.login);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr.skip,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(),

        ///<================= MAIN ILLUSTRATION =========================>///
        const OnboardingIllustration2(),

        SizedBox(height: 10.h),

        ///<================= DESCRIPTION TEXT =========================>///
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            tr.scrubPocketsTitle,
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
            tr.scrubPocketsDesc,
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
