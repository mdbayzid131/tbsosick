import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/themes/app_theme.dart';

import '../../../../controllers/tutorial_controller.dart';
import '../../../../widgets/custom_elevated_button.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

class StepCreateCard1 extends StatelessWidget {
  const StepCreateCard1({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final controller = Get.find<TutorialController>();

    return Padding(
      // 🔹 Horizontal padding responsive
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 🔹 Top spacing
          SizedBox(height: 20.h),

          /// 🔹 Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              tr.createFirstCard,
              style: GoogleFonts.arimo(
                fontSize: 24.sp, // responsive font
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(height: 6.h),

          /// 🔹 Subtitle
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              tr.tutorialFollow,
              style: GoogleFonts.arimo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff4A5565),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          /// 🔹 Main card section (takes remaining space safely)
          Expanded(
            child: Center(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(22.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  // 🔹 Prevents overflow on small screens
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// 🔹 Play icon
                      Container(
                        height: 80.w,
                        width: 80.w,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 48.sp,
                        ),
                      ),

                      SizedBox(height: 14.h),

                      /// 🔹 Card title
                      Text(
                        tr.quickStartGuide,
                        style: GoogleFonts.arimo(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      /// 🔹 Description
                      Text(
                        tr.quickStartDesc,
                        style: GoogleFonts.arimo(
                          fontSize: 14.sp,
                          color: const Color(0xff4A5565),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 18.h),

                      /// 🔹 Step list
                      _stepItem('1', tr.startProcedure),
                      SizedBox(height: 10.h),
                      _stepItem('2', tr.logKeyMoments),
                      SizedBox(height: 10.h),
                      _stepItem('3', tr.addVoiceNotes),
                      SizedBox(height: 10.h),
                      _stepItem('4', tr.finalizeCard),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          /// 🔹 Instruction text
          Text(
            tr.tapStartProcedure,
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff364153),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20.h),

          /// 🔹 CTA button
          CustomElevatedButton(
            onPressed: controller.next,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              minimumSize: Size(double.infinity, 55.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            label: tr.startProcedure,
          ),
        ],
      ),
    );
  }
}

Widget _stepItem(String number, String text) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: const Color(0xffF7F7FB),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      children: [
        /// 🔹 Step number circle
        Container(
          height: 32.w,
          width: 32.w,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: AppTheme.primaryColor.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.arimo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ),

        SizedBox(width: 10.w),

        /// 🔹 Step text
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              color: const Color(0xff364153),
            ),
          ),
        ),
      ],
    ),
  );
}
