import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingIllustration1 extends StatelessWidget {
  const OnboardingIllustration1({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Yellow Background Card
          Transform.translate(
            offset: Offset(20.w, -10.h),
            child: Transform.rotate(
              angle: 0.05,
              child: Container(
                width: 260.w,
                height: 340.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(32.r),
                ),
              ),
            ),
          ),

          // Main Digital Card
          Container(
            width: 260.w,
            height: 380.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32.r),
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
                // Top Bar (Status Bar like)
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '9:41',
                        style: GoogleFonts.arimo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 22.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5.w),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),

                // Purple Header Section
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preference Card',
                        style: GoogleFonts.arimo(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Dr. Johnson',
                        style: GoogleFonts.arimo(
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Body content lines
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLine(180.w),
                        SizedBox(height: 12.h),
                        _buildLine(160.w),
                        SizedBox(height: 12.h),
                        _buildLine(120.w),

                        SizedBox(height: 24.h),

                        // Highlighted green row
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Container(
                                height: 6.h,
                                width: 140.w,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF10B981,
                                  ).withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),
                        _buildLine(180.w),
                        SizedBox(height: 12.h),
                        _buildLine(140.w),
                      ],
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

  Widget _buildLine(double width) {
    return Container(
      height: 8.h,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
