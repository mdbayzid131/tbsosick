import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingIllustration2 extends StatelessWidget {
  const OnboardingIllustration2({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Decoration (Floating Circles)
          Positioned(
            right: 40.w,
            top: 200.h,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD1E9FF).withValues(alpha: 0.6),
              ),
            ),
          ),
          Positioned(
            right: 60.w,
            top: 220.h,
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD1E9FF).withValues(alpha: 0.8),
              ),
            ),
          ),

          // Main Device Frame
          Container(
            width: 260.w,
            height: 450.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40.r),
              border: Border.all(color: const Color(0xFF1F2937), width: 8.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 40.r,
                  offset: Offset(0, 20.h),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Notch Area
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '9:41',
                        style: GoogleFonts.arimo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      Container(
                        width: 18.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5.w),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Title
                Text(
                  'Start Procedure',
                  style: GoogleFonts.arimo(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),

                SizedBox(height: 30.h),

                // Buttons
                _buildButton(
                  text: 'New Preference\nCard',
                  color: const Color(0xFF8B5CF6),
                  textColor: Colors.white,
                ),
                SizedBox(height: 16.h),
                _buildButton(
                  text: 'Quick Log',
                  color: Colors.white,
                  textColor: const Color(0xFF111827),
                  hasBorder: true,
                ),
                SizedBox(height: 16.h),
                _buildButton(
                  text: 'View Library',
                  color: Colors.white,
                  textColor: const Color(0xFF111827),
                  hasBorder: true,
                ),

                const Spacer(),

                // Bottom text
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Text(
                    'Large touch targets for\ngloved hands',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.arimo(
                      fontSize: 12.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    bool hasBorder = false,
  }) {
    return Container(
      width: 180.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        border: hasBorder
            ? Border.all(color: const Color(0xFFE5E7EB), width: 1.w)
            : null,
        boxShadow: [
          if (!hasBorder)
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 15.r,
              offset: Offset(0, 8.h),
            ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.arimo(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
