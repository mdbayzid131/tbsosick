import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingIllustration3 extends StatelessWidget {
  const OnboardingIllustration3({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow
          Container(
            height: 300.h,
            width: 300.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF10B981).withValues(alpha: 0.1),
                  const Color(0xFF10B981).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),

          // Main Shield Icon
          Transform.translate(
            offset: Offset(-20.w, 0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 200.sp,
                  color: const Color(0xFF10B981),
                ),
                Positioned(
                  top: 75.h,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Digital Card leaning against shield
          Positioned(
            right: 40.w,
            bottom: 80.h,
            child: Transform.rotate(
              angle: 0.1,
              child: Container(
                width: 160.w,
                height: 220.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildColorLine(const Color(0xFFEF4444), 120.w),
                      SizedBox(height: 6.h),
                      _buildColorLine(const Color(0xFFEF4444), 90.w),
                      SizedBox(height: 12.h),
                      _buildColorLine(const Color(0xFFD8B4FE), 110.w),
                      SizedBox(height: 6.h),
                      _buildColorLine(const Color(0xFFD8B4FE), 80.w),
                      const Spacer(),
                      Center(
                        child: Text(
                          'No Patient Data',
                          style: GoogleFonts.arimo(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating Badges
          _buildBadge(text: 'HIPAA', offset: Offset(-100.w, -120.h)),
          _buildBadge(text: 'Encrypted', offset: Offset(80.w, -110.h)),
          _buildBadge(text: 'Secure', offset: Offset(-80.w, 80.h)),
        ],
      ),
    );
  }

  Widget _buildColorLine(Color color, double width) {
    return Container(
      height: 14.h,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  Widget _buildBadge({required String text, required Offset offset}) {
    return Transform.translate(
      offset: offset,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.arimo(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }
}
