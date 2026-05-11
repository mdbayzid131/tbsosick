import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';
import 'package:tbsosick/presentation/screens/ProfilePage/controller/subscription_controller.dart';
import '../../../../config/constants/image_paths.dart';
import '../Payment Method bottom.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          tr.choosePlanTitle,
          style: GoogleFonts.arimo(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 32.h),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFf9945FF), Color(0xFF7B2FD4)],
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 64.w,
                            width: 64.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.20),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '⭐️',
                                style: GoogleFonts.arimo(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            tr.unlockSmrtscrub,
                            style: GoogleFonts.arimo(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            tr.chooseWorksForYou,
                            style: GoogleFonts.arimo(
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr.choosePlanTitle,
                            style: GoogleFonts.arimo(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Free
                          GestureDetector(
                            onTap: () => controller.selectPlan(0),
                            child: Obx(
                              () => _planCard(
                                title: tr.freePlanTitle,
                                price: '\$0 ',
                                features: [
                                  '2 basic preference cards',
                                  'No library access',
                                  'No calendar',
                                  'Email support',
                                ],
                                isSelected: controller.selectedPlan.value == 0,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Premium
                          GestureDetector(
                            onTap: () => controller.selectPlan(1),
                            child: Obx(
                              () => _planCard(
                                title: tr.premiumPlanTitle,
                                price: controller.premiumProduct.value?.price ?? '\$5.99',
                                badge: tr.popularBadge,
                                features: [
                                  '20 preference cards',
                                  'Basic calendar',
                                  'Access to public library (upload & download)',
                                  'No team collaboration',
                                  'No verified card',
                                ],
                                isSelected: controller.selectedPlan.value == 1,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Enterprise
                          GestureDetector(
                            onTap: () => controller.selectPlan(2),
                            child: Obx(
                              () => _planCard(
                                title: tr.enterprisePlanTitle,
                                price: controller.enterpriseProduct.value?.price ?? '\$9.99',
                                features: [
                                  'Unlimited cards',
                                  'Advanced calendar',
                                  'Access to public library (upload & download)',
                                  'Team collaboration',
                                  'Verified preference cards',
                                ],
                                isSelected: controller.selectedPlan.value == 2,
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),

                          Obx(() => CustomElevatedButton(
                            label: controller.selectedPlan.value == 0 
                                ? tr.updatePaymentMethod 
                                : 'Subscribe Now',
                            onPressed: () {
                              if (controller.selectedPlan.value == 0) {
                                showPaymentMethodBottomSheet(context);
                              } else {
                                controller.subscribe();
                              }
                            },
                          )),
                          SizedBox(height: 20.h),
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
  }

  Widget _planCard({
    required String title,
    required String price,
    required List<String> features,
    bool isSelected = false,
    String? badge,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryColor.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : const Color(0xffC6C6C8),
          width: isSelected ? 2.w : 1.w,
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff14F195),
                    borderRadius: BorderRadius.circular(12.r),
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
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: const Color(0xff9945FF),
                  size: 20.sp,
                ),
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
                  color: const Color(0xff8E8E93),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
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
}
