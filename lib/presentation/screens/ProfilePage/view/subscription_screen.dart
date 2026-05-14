import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/core/utils/helpers.dart';
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
        actions: [
          TextButton(
            onPressed: controller.restorePurchases,
            child: Text(
              'Restore',
              style: GoogleFonts.arimo(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Gradient
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFf9945FF), Color(0xFF7B2FD4)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 56.w,
                    width: 56.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.20),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('🚀', style: TextStyle(fontSize: 24.sp)),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    tr.unlockSmrtscrub,
                    style: GoogleFonts.arimo(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    tr.chooseWorksForYou,
                    style: GoogleFonts.arimo(
                      fontSize: 13.sp,
                      color: Colors.white.withOpacity(.9),
                    ),
                  ),
                ],
              ),
            ),

            // TabBar for Monthly/Yearly
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              height: 45.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TabBar(
                controller: controller.tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: AppTheme.primaryColor,
                ),
                labelColor: Colors.white,
                dividerColor: Colors.transparent,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: GoogleFonts.arimo(fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: 'Monthly'),
                  Tab(text: 'Yearly'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildPlanList(
                    context,
                    controller.monthlyProducts,
                    isYearly: false,
                  ),
                  _buildPlanList(
                    context,
                    controller.yearlyProducts,
                    isYearly: true,
                  ),
                ],
              ),
            ),

            // Bottom Button
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Obx(
                () => CustomElevatedButton(
                  isLoading: controller.isLoading,
                  label: controller.isSelectedPlanCurrent
                      ? 'Current Plan'
                      : (controller.selectedPlan.value == 0
                          ? 'Select Free Plan'
                          : 'Subscribe Now'),
                  onPressed:
                      controller.isSelectedPlanCurrent ? null : controller.subscribe,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanList(
    BuildContext context,
    RxList<ProductDetails> products, {
    required bool isYearly,
  }) {
    final tr = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          // Free Plan - Always shown first
          GestureDetector(
            onTap: () => controller.selectPlan(0),
            child: Obx(
              () => _planCard(
                title: tr.freePlanTitle,
                price: '\$0',
                period: '',
                features: [
                  
                  '2 basic preference cards',
                  'No library access',
                  'Email support',
                ],
                isSelected: controller.selectedPlan.value == 0,
                currentPlan: controller.currentSubscription?.plan == 'FREE',
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Paid Plans
          Obx(() {
            if (products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: products.asMap().entries.map((entry) {
                final index = entry.key;
                final product = entry.value;

                // Index 0 is ALWAYS Premium, Index 1 is ALWAYS Enterprise due to our price mapping
                final isPremium = index == 0;
                final planIndex = isPremium ? 1 : 2;

                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: GestureDetector(
                    onTap: () => controller.selectPlan(planIndex),
                    child: _planCard(
                      title: isPremium
                          ? tr.premiumPlanTitle
                          : tr.enterprisePlanTitle,
                      price: product.price,
                      period: isYearly ? '/year' : '/month',
                      badge: isPremium ? tr.popularBadge : null,
                      features: isPremium
                          ? [
                              '20 preference cards',
                              'Basic calendar',
                              'Access to public library',
                            ]
                          : [
                              'Unlimited cards',
                              'Advanced calendar',
                              'Team collaboration',
                              'Verified cards',
                            ],
                      isSelected: controller.selectedPlan.value == planIndex,
                      currentPlan: (isPremium 
                          ? controller.currentSubscription?.plan == 'PREMIUM'
                          : controller.currentSubscription?.plan == 'ENTERPRISE') &&
                          (controller.currentSubscription?.productId?.contains(isYearly ? 'yearly' : 'monthly') ?? true),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _planCard({
    required String title,
    required String price,
    required String period,
    required List<String> features,
    bool isSelected = false,
    bool currentPlan = false,
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
              if (currentPlan)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Current Plan',
                    style: GoogleFonts.arimo(
                      fontSize: 11.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else if (isSelected)
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
              if (period.isNotEmpty) ...[
                SizedBox(width: 4.w),
                Text(
                  period,
                  style: GoogleFonts.arimo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff8E8E93),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          ...features.map(
            (f) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  Icon(Icons.check, color: AppTheme.primaryColor, size: 16.sp),
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
