import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

void showTermsOfServiceBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final tr = AppLocalizations.of(context)!;
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.fromLTRB(20.w, 15.w, 20.w, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr.termsOfService,
                    style: GoogleFonts.arimo(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 36.h,
                      width: 36.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2F2F7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: const Color(0xFF1C1B1F),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Acceptance of Terms
                      _buildSectionTitle(tr.terms1Title),
                      SizedBox(height: 8.h),
                      _buildSectionContent(tr.terms1Desc),

                      SizedBox(height: 24.h),

                      // 2. Use of Service
                      _buildSectionTitle(tr.terms2Title),
                      SizedBox(height: 8.h),
                      _buildSectionContent(tr.terms2Desc),

                      SizedBox(height: 24.h),

                      // 3. Privacy Policy
                      _buildSectionTitle(tr.terms3Title),
                      SizedBox(height: 8.h),
                      _buildSectionContent(tr.terms3Desc),

                      SizedBox(height: 24.h),

                      // 4. Termination
                      _buildSectionTitle(tr.terms4Title),
                      SizedBox(height: 8.h),
                      _buildSectionContent(tr.terms4Desc),

                      SizedBox(height: 24.h),

                      // 5. Disclaimer of Warranties
                      _buildSectionTitle(tr.terms5Title),
                      SizedBox(height: 8.h),
                      _buildSectionContent(tr.terms5Desc),

                      SizedBox(height: 24.h),

                      // 6. Limitation of Liability
                      _buildSectionTitle(tr.terms6Title),
                      SizedBox(height: 8.h),
                      _buildSectionContent(tr.terms6Desc),

                      SizedBox(height: 24.h),

                      // 7. Governing Law
                      _buildSectionTitle(tr.terms7Title),
                      SizedBox(height: 8.h),
                      _buildSectionContent(tr.terms7Desc),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),

              // Close button at bottom
              SizedBox(height: 16.h),
              SizedBox(
                height: 50.h,
                child: CustomElevatedButton(
                  onPressed: () => Get.back(),
                  label: tr.close,
                ),
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      );
    },
  );
}

// Section title widget
Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: GoogleFonts.arimo(
      fontSize: 15.sp,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF000000),
    ),
  );
}

// Section content widget
Widget _buildSectionContent(String content) {
  return Text(
    content,
    style: GoogleFonts.arimo(
      fontSize: 13.sp,
      color: const Color(0xFF8E8E93),
      height: 1.6,
    ),
  );
}
