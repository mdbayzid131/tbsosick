import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/themes/app_theme.dart';

import '../../../../controllers/tutorial_controller.dart';
import '../../../../widgets/custom_elevated_button.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

class StepCreateCard2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final controller = Get.find<TutorialController>();

    return Padding(
      // 🔹 Responsive horizontal padding
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
              tr.logImportantMoments,
              style: GoogleFonts.arimo(
                fontSize: 24.sp,
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
              tr.trackMilestones,
              style: GoogleFonts.arimo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff4A5565),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          /// 🔹 Main preview card (takes remaining height safely)
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
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  // 🔹 Prevents overflow on small devices
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 Header row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔹 Procedure info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr.newProcedure,
                                  style: GoogleFonts.arimo(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  tr.totalKneeReplacement,
                                  style: GoogleFonts.arimo(
                                    fontSize: 14.sp,
                                    color: const Color(0xff4A5565),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// 🔹 Time info
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16.sp,
                                color: const Color(0xff8E8E93),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '08:00 AM',
                                style: GoogleFonts.arimo(
                                  fontSize: 13.sp,
                                  color: const Color(0xff8E8E93),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 18.h),

                      /// 🔹 Highlight action card
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff8F3CFF), Color(0xff7A2CF3)],
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            /// 🔹 Action text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr.nextStep,
                                    style: GoogleFonts.arimo(
                                      fontSize: 12.sp,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    tr.timeOutRequired,
                                    style: GoogleFonts.arimo(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// 🔹 Icon bubble
                            Container(
                              height: 32.w,
                              width: 32.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          /// 🔹 Instruction text
          Text(
            tr.tapTimeOut,
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff364153),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20.h),

          /// 🔹 Primary action button
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

          SizedBox(height: 20.h),

          /// 🔹 Skip action
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
        ],
      ),
    );
  }
}
