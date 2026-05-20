import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_elevated_button.dart';

void showResetPasswordSuccessBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Success!',
                        style: GoogleFonts.arimo(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 32.h,
                          width: 32.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffF2F2F7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9FFF3),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.green, width: 1.w),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Password reset successful!',
                            style: GoogleFonts.arimo(
                              fontSize: 14.sp,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    "You can now log in using your new password.",
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      color: const Color(0xff8E8E93),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  CustomElevatedButton(
                    label: 'Done',
                    onPressed: () {
                      Get.back(); // close success sheet
                      // Optional: Navigate to login
                    },
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
