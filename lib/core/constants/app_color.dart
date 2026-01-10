import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xff9945FF);
  static const Color secondary = Color(0xFFFF6584);
  static const Color bg = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF6C6C6C);

  static final TextStyle titleTextStyle = GoogleFonts.arimo(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    color: Color(0xff101828),
  );
  static final TextStyle subTitleTextStyle = GoogleFonts.arimo(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xff4A5565),
  );
}
