import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/screens/auth_screen/reset_password_bottom2.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/image_paths.dart';
import '../../../../routes/routes.dart';
import 'Payment Method bottom.dart';

void showUpdatePackageBottomSheet(BuildContext context) {
  final selectedPlan = 1.obs;

  showModalBottomSheet(
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.fromLTRB(0, 16.w, 0, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
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
              ),
              SizedBox(height: 5.h),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 24, bottom: 28),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFf9945FF), Color(0xFF7B2FD4)],
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 12),

                            Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.20),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '⭐️',
                                  style: GoogleFonts.arimo(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 16),

                            Text(
                              'Unlock SMRTSCRUB',
                              style: GoogleFonts.arimo(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              'Choose the plan that works for you',
                              style: GoogleFonts.arimo(
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 16),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Choose a Plan',
                                style: GoogleFonts.arimo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),

                            // Free
                            GestureDetector(
                              onTap: () => selectedPlan.value = 0,
                              child: Obx(
                                () => _planCard(
                                  title: 'Free',
                                  price: '\$0 ',
                                  features: [
                                    '2 basic preference cards',
                                    'No library access',
                                    'No calendar',
                                    'Email support',
                                  ],
                                  isSelected: selectedPlan.value == 0,
                                ),
                              ),
                            ),

                            SizedBox(height: 16.h),

                            // Premium
                            GestureDetector(
                              onTap: () => selectedPlan.value = 1,
                              child: Obx(
                                () => _planCard(
                                  title: 'Premium',
                                  price: '\$5.99',
                                  badge: 'Popular',
                                  features: [
                                    '20 preference cards',
                                    'Basic calendar',
                                    'Access to public library (upload & download)',
                                    'No team collaboration',
                                    'No verified card',
                                  ],
                                  isSelected: selectedPlan.value == 1,
                                  showCheck: true,
                                ),
                              ),
                            ),

                            SizedBox(height: 16),

                            // Enterprise
                            GestureDetector(
                              onTap: () => selectedPlan.value = 2,
                              child: Obx(
                                () => _planCard(
                                  title: 'Enterprise',
                                  price: '\$9.99',
                                  badge: 'Popular',
                                  features: [
                                    'Unlimited cards',
                                    'Advanced calendar',
                                    'Access to public library (upload & download)',
                                    'Team collaboration',
                                    'Verified preference cards',
                                  ],
                                  isSelected: selectedPlan.value == 2,
                                ),
                              ),
                            ),
                            SizedBox(height: 25),

                            CustomElevatedButton(
                              label: 'Update Payment Method',
                              onPressed: () {
                                showPaymentMethodBottomSheet(context);
                                // TODO: Navigate to update payment method
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _planCard({
  required String title,
  required String price,
  required List<String> features,
  bool isSelected = false,
  bool showCheck = false,
  String? badge,
}) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isSelected ? AppColors.primary : Color(0xffC6C6C8),
        width: isSelected ? 2 : 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.arimo(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (badge != null) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xff14F195),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.arimo(
                    fontSize: 11.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: Color(0xff9945FF), size: 20.sp),
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Text(
              price,
              style: GoogleFonts.arimo(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '/month',
              style: GoogleFonts.arimo(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff8E8E93),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...features.map(
          (f) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImagePaths.chosePlanIcon,
                  width: 16.w,
                  height: 16.w,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    f,
                    style: GoogleFonts.arimo(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
