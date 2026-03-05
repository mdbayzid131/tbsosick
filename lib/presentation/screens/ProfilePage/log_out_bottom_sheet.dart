import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/controllers/login_controller.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

void showSignOutConfirmationBottomSheet(BuildContext context) {
  final controller = Get.find<LoginController>();
  final tr = AppLocalizations.of(context)!;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        padding: EdgeInsets.fromLTRB(20.w, 15.w, 20.w, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr.signOut,
                      style: GoogleFonts.arimo(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 32.w,
                        width: 32.w,
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

                SizedBox(height: 32.h),

                // Confirmation question
                Text(
                  tr.signOutConfirm,
                  style: GoogleFonts.arimo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                    height: 1.3,
                  ),
                ),

                SizedBox(height: 16.h),

                // Description text
                Text(
                  tr.signOutDesc,
                  style: GoogleFonts.arimo(
                    fontSize: 13.sp,
                    color: const Color(0xFF8E8E93),
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 32.h),

                // Action buttons
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF2F2F7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          elevation: 0,
                        ),
                        child: Text(
                          tr.cancel,
                          style: GoogleFonts.arimo(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9945FF),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Sign Out button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3B30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          elevation: 0,
                        ),
                        child: Text(
                          tr.signOut,
                          style: GoogleFonts.arimo(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      );
    },
  );
}
