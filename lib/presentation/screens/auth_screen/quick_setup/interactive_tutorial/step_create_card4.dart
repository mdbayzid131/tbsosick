import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/themes/app_theme.dart';

import '../../../../../config/constants/image_paths.dart';
import '../../../../controllers/tutorial_controller.dart';
import '../../../../widgets/custom_elevated_button.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

class StepCreateCard4 extends StatelessWidget {
  const StepCreateCard4({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final controller = Get.find<TutorialController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),

          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              tr.reviewCard,
              style: GoogleFonts.arimo(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(height: 6.h),

          // Subtitle
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              tr.formattedCard,
              style: GoogleFonts.arimo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff4A5565),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Card preview section
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Card title
                      Text(
                        tr.preferenceCardSummary,
                        style: GoogleFonts.arimo(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff101828),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      Text(
                        tr.reviewFinalize,
                        style: GoogleFonts.arimo(
                          fontSize: 14.sp,
                          color: const Color(0xff4A5565),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Procedure block
                      _infoBox(
                        title: tr.procedure,
                        child: Text(
                          tr.totalKneeReplacement,
                          style: GoogleFonts.arimo(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff101828),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Timeline block
                      _infoBox(
                        title: tr.timeline,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              ImagePaths.chosePlanIcon,
                              width: 18.w,
                              height: 18.w,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Time Out  •  08:00 AM',
                              style: GoogleFonts.arimo(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Instrument notes block
                      _infoBox(
                        title: tr.instrumentNotes,
                        child: Text(
                          '"${tr.instrumentExample}"',
                          style: GoogleFonts.arimo(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Footer text
          Text(
            tr.tapFinalize,
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff364153),
            ),
          ),

          SizedBox(height: 20.h),

          // Finalize button
          CustomElevatedButton(
            onPressed: controller.finalizeSetup,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              minimumSize: Size(double.infinity, 55.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            label: tr.finalize,
          ),

          SizedBox(height: 20.h),

          // Skip action
          GestureDetector(
            onTap: controller.skip,
            child: Text(
              tr.skipTutorial,
              style: GoogleFonts.arimo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff364153),
              ),
            ),
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

// Reusable info container
Widget _infoBox({required String title, required Widget child}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(14.w),
    decoration: BoxDecoration(
      color: const Color(0xffF9FAFB),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.arimo(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff6A7282),
          ),
        ),
        SizedBox(height: 6.h),
        child,
      ],
    ),
  );
}
