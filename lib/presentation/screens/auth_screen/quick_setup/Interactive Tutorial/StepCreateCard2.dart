import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/image_paths.dart';
import '../../../../controllers/tutorial_controller.dart';
import '../../../../widgets/custom_elevated_button.dart';

Widget StepCreateCard2() {
  final controller = Get.find<TutorialController>();

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20.h),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Log Important Moments",
            style: GoogleFonts.arimo(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 6.h),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Track key surgical milestones with one tap",
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff4A5565),
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 20.h),

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Procedure',
                              style: GoogleFonts.arimo(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Total Knee Replacement',
                              style: GoogleFonts.arimo(
                                fontSize: 14.sp,
                                color: const Color(0xff4A5565),
                              ),
                            ),
                          ],
                        ),
                      ),
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

                  // Highlight action card
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff8F3CFF),
                          Color(0xff7A2CF3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Next Step',
                                style: GoogleFonts.arimo(
                                  fontSize: 12.sp,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Time Out Required',
                                style: GoogleFonts.arimo(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
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

        SizedBox(height: 16.h),

        Text(
          'Tap "Time Out" to log the safety checklist',
          style: GoogleFonts.arimo(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff364153),
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 20.h),

        CustomElevatedButton(
          onPressed: controller.next,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: Size(double.infinity, 55.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          label: 'Start Procedure',
        ),

        SizedBox(height: 20.h),

        GestureDetector(
          onTap: controller.skip,
          child: Text(
            'Skip Tutorial',
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
