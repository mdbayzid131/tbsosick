import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/constants/storage_constants.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/core/services/storage_service.dart';

import '../../../../../config/constants/image_paths.dart';
import '../../../../controllers/tutorial_controller.dart';
import '../../../../widgets/custom_elevated_button.dart';

Widget StepCreateCard4() {
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
            "Review Your Card",
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
            "See your clean, formatted preference card",
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
                    color: Colors.black.withOpacity(0.08),
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
                      'Preference Card Summary',
                      style: GoogleFonts.arimo(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff101828),
                      ),
                    ),
                
                    SizedBox(height: 4.h),
                
                    Text(
                      'Review and finalize',
                      style: GoogleFonts.arimo(
                        fontSize: 14.sp,
                        color: const Color(0xff4A5565),
                      ),
                    ),
                
                    SizedBox(height: 16.h),
                
                    // Procedure block
                    _infoBox(
                      title: "Procedure",
                      child: Text(
                        'Total Knee Replacement',
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
                      title: "Timeline",
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
                      title: "Instrument Notes",
                      child: Text(
                        '"Prefer DeBakey forceps and Metzenbaum scissors for this procedure"',
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
          'Tap "Finalize" to complete',
          style: GoogleFonts.arimo(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff364153),
          ),
        ),

        SizedBox(height: 20.h),

        // Finalize button
        CustomElevatedButton(
          onPressed: (){
            StorageService.setBool(StorageConstants.quickSetupCompleted, true);
            Get.offAllNamed(AppRoutes.BOTTOM_NAV_BAR);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            minimumSize: Size(double.infinity, 55.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          label: 'Finalize Card',
        ),

        SizedBox(height: 20.h),

        // Skip action
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

        SizedBox(height: 10.h),
      ],
    ),
  );
}

// Reusable info container
Widget _infoBox({
  required String title,
  required Widget child,
}) {
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
