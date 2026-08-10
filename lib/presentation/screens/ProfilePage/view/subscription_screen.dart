import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/presentation/screens/ProfilePage/controller/subscription_controller.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  static const Color primaryColor = Color(0xFF9945FF);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color emeraldGreen = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_new, color: textDark, size: 16.sp),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Subscription',
          style: GoogleFonts.arimo(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: controller.restorePurchases,
            child: Text(
              'Restore',
              style: GoogleFonts.arimo(
                color: primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header & Segmented Toggle Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  child: Column(
                    children: [
                      // Active Plan Banner or Header
                      _buildCurrentPlanIndicator(context),
                      SizedBox(height: 10.h),

                      // Title (Only visible for Free Tier users)
                      Obx(() {
                        if (controller.currentPlanTier > 0) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            Text(
                              'Upgrade Your Plan',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.arimo(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: textDark,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Choose the plan that fits your needs.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.arimo(
                                fontSize: 13.sp,
                                color: textMuted,
                              ),
                            ),
                            SizedBox(height: 12.h),
                          ],
                        );
                      }),

                      // Segmented Toggle (Monthly / Yearly)
                      _buildSegmentedToggle(context),
                    ],
                  ),
                ),

                // Scrollable Plan Cards & Footer
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSubscriptionCards(context),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 16.h,
                                    bottom: 8.h,
                                  ),
                                  child: _buildFooterSection(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Obx(() {
              if (controller.isLoading) {
                return Container(
                  color: Colors.black.withValues(alpha: 0.2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Current Plan Header / Active Plan Banner (Clean Style)
  // ---------------------------------------------------------------------------
  Widget _buildCurrentPlanIndicator(BuildContext context) {
    return Obx(() {
      final sub = controller.currentSubscription;
      final tier = controller.currentPlanTier;

      if (sub != null && tier > 0) {
        final isYearly =
            sub.productId?.toLowerCase().contains('yearly') ?? false;
        final planName = sub.plan.toUpperCase();
        final endDate = sub.currentPeriodEnd;
        final formattedDate = endDate != null
            ? '${_getMonthName(endDate.month)} ${endDate.day}, ${endDate.year}'
            : 'N/A';

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F3FF),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFDDD6FE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tier == 2
                              ? Icons.diamond_outlined
                              : Icons.workspace_premium_outlined,
                          color: primaryColor,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'ACTIVE PLAN',
                          style: GoogleFonts.arimo(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF5B21B6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEF7EC),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      sub.status.toUpperCase(),
                      style: GoogleFonts.arimo(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF03543F),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                '$planName ${isYearly ? "(Yearly)" : "(Monthly)"}',
                style: GoogleFonts.arimo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Text(
                    'Renews on: $formattedDate',
                    style: GoogleFonts.arimo(fontSize: 12.sp, color: textMuted),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: controller.manageSubscription,
                    child: Text(
                      'Manage',
                      style: GoogleFonts.arimo(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      // Free Plan indicator
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: const BoxDecoration(
                color: emeraldGreen,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Current Plan: ',
              style: GoogleFonts.arimo(fontSize: 12.sp, color: textMuted),
            ),
            Text(
              'Free Tier',
              style: GoogleFonts.arimo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: textDark,
              ),
            ),
          ],
        ),
      );
    });
  }

  static String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[(month - 1) % 12];
  }

  // ---------------------------------------------------------------------------
  // 2. Segmented Toggle (Clean Minimal Style)
  // ---------------------------------------------------------------------------
  Widget _buildSegmentedToggle(BuildContext context) {
    return Container(
      height: 42.h,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: controller.tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: primaryColor,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: textMuted,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.arimo(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.arimo(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          const Tab(text: 'Monthly'),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Yearly'),
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEF7EC),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Save 25%',
                    style: GoogleFonts.arimo(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF03543F),
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

  // ---------------------------------------------------------------------------
  // 3. Subscription Cards Display
  // ---------------------------------------------------------------------------
  Widget _buildSubscriptionCards(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.tabController,
      builder: (context, _) {
        final isYearly = controller.tabController.index == 1;
        final products = isYearly
            ? controller.yearlyProducts
            : controller.monthlyProducts;

        return Obx(() {
          String premiumPrice = isYearly ? '\$79.99' : '\$9.99';
          String enterprisePrice = isYearly ? '\$149.99' : '\$19.99';

          if (products.isNotEmpty) {
            premiumPrice = products[0].price;
            if (products.length > 1) {
              enterprisePrice = products[1].price;
            }
          }

          final isPremiumDisabled = controller.isPlanDisabled(
            1,
            isYearly: isYearly,
          );
          final isEnterpriseDisabled = controller.isPlanDisabled(
            2,
            isYearly: isYearly,
          );

          final isPremiumCurrent = controller.isPlanCurrent(
            1,
            isYearly: isYearly,
          );
          final isEnterpriseCurrent = controller.isPlanCurrent(
            2,
            isYearly: isYearly,
          );

          return Column(
            children: [
              _buildPlanCard(
                context,
                planIndex: 1,
                title: 'Premium',
                price: premiumPrice,
                period: isYearly ? '/year' : '/month',
                subtitle: 'Essential power for surgical professionals',
                badgeText: 'Most Popular',
                badgeBg: const Color(0xFFF3E8FF),
                badgeTextColor: const Color(0xFF6B21A8),
                iconData: Icons.workspace_premium_outlined,
                features: const [
                  '20 Preference Cards / Month',
                  'Calendar Sync & Public Library Access',
                  'Standard Search & Email Support',
                ],
                isSelected: controller.selectedPlan.value == 1,
                isCurrent: isPremiumCurrent,
                isDisabled: isPremiumDisabled,
                ctaText: isPremiumCurrent
                    ? 'Current Plan'
                    : (isPremiumDisabled ? 'Plan Active' : 'Get Premium'),
              ),
              SizedBox(height: 12.h),
              _buildPlanCard(
                context,
                planIndex: 2,
                title: 'Enterprise',
                price: enterprisePrice,
                period: isYearly ? '/year' : '/month',
                subtitle: 'Unlimited access & advanced team features',
                badgeText: 'Best Value',
                badgeBg: const Color(0xFFE0E7FF),
                badgeTextColor: const Color(0xFF3730A3),
                iconData: Icons.diamond_outlined,
                features: const [
                  'Unlimited Preference Cards',
                  'Advanced Team Collaboration & Sharing',
                  '24/7 Priority Support & Future Updates',
                ],
                isSelected: controller.selectedPlan.value == 2,
                isCurrent: isEnterpriseCurrent,
                isDisabled: isEnterpriseDisabled,
                ctaText: isEnterpriseCurrent
                    ? 'Current Plan'
                    : (isEnterpriseDisabled
                          ? 'Plan Active'
                          : (controller.currentPlanTier == 1
                                ? 'Upgrade to Enterprise'
                                : 'Get Enterprise')),
              ),
            ],
          );
        });
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Individual Plan Card Widget (Clean & Minimal)
  // ---------------------------------------------------------------------------
  Widget _buildPlanCard(
    BuildContext context, {
    required int planIndex,
    required String title,
    required String price,
    required String period,
    required String subtitle,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
    required IconData iconData,
    required List<String> features,
    required bool isSelected,
    required bool isCurrent,
    required bool isDisabled,
    required String ctaText,
  }) {
    final isHighlight = (isSelected || isCurrent) && !isDisabled;

    return GestureDetector(
      onTap: () => controller.selectPlan(planIndex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isHighlight ? const Color(0xFFFAF5FF) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isHighlight ? primaryColor : cardBorder,
            width: isHighlight ? 1.5.w : 1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(iconData, color: primaryColor, size: 20.sp),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.arimo(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.arimo(
                          fontSize: 11.sp,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrent)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEF7EC),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Current',
                      style: GoogleFonts.arimo(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF03543F),
                      ),
                    ),
                  )
                else if (isDisabled)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Lower Tier',
                      style: GoogleFonts.arimo(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      badgeText,
                      style: GoogleFonts.arimo(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: badgeTextColor,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),

            // Price Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  price,
                  style: GoogleFonts.arimo(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  period,
                  style: GoogleFonts.arimo(fontSize: 13.sp, color: textMuted),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            const Divider(height: 1, color: cardBorder),
            SizedBox(height: 10.h),

            // Features
            ...features.map(
              (feature) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: emeraldGreen,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        feature,
                        style: GoogleFonts.arimo(
                          fontSize: 12.sp,
                          color: textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // CTA Button (Clean Flat Style)
            SizedBox(
              width: double.infinity,
              height: 42.h,
              child: ElevatedButton(
                onPressed: (isCurrent || isDisabled || controller.isLoading)
                    ? null
                    : () {
                        controller.selectPlan(planIndex);
                        controller.subscribe();
                      },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: (isCurrent || isDisabled)
                      ? const Color(0xFFF3F4F6)
                      : primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  ctaText,
                  style: GoogleFonts.arimo(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: (isCurrent || isDisabled) ? textMuted : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. Footer Section
  // ---------------------------------------------------------------------------
  Widget _buildFooterSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, color: textMuted, size: 14.sp),
            SizedBox(width: 6.w),
            Text(
              'Secured with Google Play & App Store',
              style: GoogleFonts.arimo(fontSize: 12.sp, color: textMuted),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          'Auto-renews until canceled. Cancel anytime in store settings.',
          textAlign: TextAlign.center,
          style: GoogleFonts.arimo(fontSize: 11.sp, color: textMuted),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () =>
                  controller.launchLegalUrl('https://smrtscrub.app/terms'),
              child: Text(
                'Terms of Service',
                style: GoogleFonts.arimo(
                  fontSize: 12.sp,
                  color: textMuted,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                '•',
                style: TextStyle(color: textMuted, fontSize: 12.sp),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  controller.launchLegalUrl('https://smrtscrub.app/privacy'),
              child: Text(
                'Privacy Policy',
                style: GoogleFonts.arimo(
                  fontSize: 12.sp,
                  color: textMuted,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        Obx(() {
          final hasActiveSub = controller.currentPlanTier > 0;

          if (!Get.currentRoute.contains(AppRoutes.selectPackage)) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: EdgeInsets.only(top: 14.h),
            child: SizedBox(
              width: double.infinity,
              height: 44.h,
              child: hasActiveSub
                  ? ElevatedButton(
                      onPressed: () =>
                          Get.toNamed(AppRoutes.whatYourSpeciality),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: GoogleFonts.arimo(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    )
                  : OutlinedButton(
                      onPressed: controller.chooseFreePlanAndProceed,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        side: const BorderSide(color: primaryColor, width: 1.2),
                      ),
                      child: Text(
                        'Continue with Free Plan',
                        style: GoogleFonts.arimo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
            ),
          );
        }),
      ],
    );
  }
}
