import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../controllers/tutorial_controller.dart';
import '../../../../widgets/custom_elevated_button.dart';

Widget StepCreateCard3() {
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
            "Add Voice Notes",
            style: GoogleFonts.arimo(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),

        SizedBox(height: 6.h),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Dictate instrument preferences hands-free",
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff4A5565),
            ),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mic icon
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff8A3AEA),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.mic_none_rounded,
                          color: Colors.white,
                          size: 55.sp,
                        ),
                      ),
                    ),
                
                    SizedBox(height: 14.h),
                
                    Text(
                      'Voice Note',
                      style: GoogleFonts.arimo(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                
                    SizedBox(height: 8.h),
                
                    Text(
                      'Hold button to record hands-free',
                      style: GoogleFonts.arimo(
                        fontSize: 14.sp,
                        color: const Color(0xff4A5565),
                      ),
                      textAlign: TextAlign.center,
                    ),
                
                    SizedBox(height: 24.h),
                
                    _bulletText('Works with surgical gloves'),
                    SizedBox(height: 8.h),
                    _bulletText('Auto-saves to your preference card'),
                    SizedBox(height: 8.h),
                    _bulletText('HIPAA compliant. no patient data'),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 16.h),

        Text(
          'Hold to record your instrument preference',
          style: GoogleFonts.arimo(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff364153),
          ),
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
          label: 'Hold to Record',
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

// Reusable bullet row
Widget _bulletText(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         Icon(
          Icons.circle,
          size: 6.sp,
          color: Colors.grey,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.arimo(
              fontSize: 12.sp,
              color: const Color(0xff4A5565),
            ),
          ),
        ),
      ],
    ),
  );
}
