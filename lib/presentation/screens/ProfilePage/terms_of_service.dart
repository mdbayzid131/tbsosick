import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';

void showTermsOfServiceBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Terms of Service',
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
                    _buildSectionTitle('1. Acceptance of Terms'),
                    SizedBox(height: 8.h),
                    _buildSectionContent(
                      'By using the SMRTSCRUB service, you agree to be bound by these Terms of Service.',
                    ),

                    SizedBox(height: 24.h),

                    // 2. Use of Service
                    _buildSectionTitle('2. Use of Service'),
                    SizedBox(height: 8.h),
                    _buildSectionContent(
                      'You agree to use the service only for lawful purposes and in a manner that does not infringe the rights of, or restrict or inhibit the use and enjoyment of the service by any third party.',
                    ),

                    SizedBox(height: 24.h),

                    // 3. Privacy Policy
                    _buildSectionTitle('3. Privacy Policy'),
                    SizedBox(height: 8.h),
                    _buildSectionContent(
                      'Your use of the service is also governed by our Privacy Policy, which is incorporated into these Terms of Service.',
                    ),

                    SizedBox(height: 24.h),

                    // 4. Termination
                    _buildSectionTitle('4. Termination'),
                    SizedBox(height: 8.h),
                    _buildSectionContent(
                      'We may terminate or suspend access to the service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach these Terms of Service.',
                    ),

                    SizedBox(height: 24.h),

                    // 5. Disclaimer of Warranties
                    _buildSectionTitle('5. Disclaimer of Warranties'),
                    SizedBox(height: 8.h),
                    _buildSectionContent(
                      'The service is provided on an "as is" and "as available" basis. We make no representations or warranties of any kind, express or implied, about the operation of the service, or the information, content, materials, or products included on the service.',
                    ),

                    SizedBox(height: 24.h),

                    // 6. Limitation of Liability
                    _buildSectionTitle('6. Limitation of Liability'),
                    SizedBox(height: 8.h),
                    _buildSectionContent(
                      'In no event will we be liable for any loss or damage including without limitation, indirect or consequential loss or damage, or any loss or damage whatsoever arising from loss of data or profits arising out of or in connection with the use of this service.',
                    ),

                    SizedBox(height: 24.h),

                    // 7. Governing Law
                    _buildSectionTitle('7. Governing Law'),
                    SizedBox(height: 8.h),
                    _buildSectionContent(
                      'These Terms of Service shall be governed by and construed in accordance with the laws of the State of California, without regard to its conflict of law principles.',
                    ),

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
                 label: 'Close',
              ),
            ),

            SizedBox(height: 10.h),
          ],
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
