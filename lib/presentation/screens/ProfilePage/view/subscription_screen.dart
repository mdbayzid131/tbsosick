import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/screens/ProfilePage/controller/subscription_controller.dart';
import 'package:tbsosick/core/utils/helpers.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  static const Color bgDark = Colors.white;
  static const Color cardDark = Colors.white;
  static const Color cardBorderDark = Color(0xFFE2E8F0);
  static const Color accentBlue = Color(0xFF9945FF); // AppTheme.primaryColor
  static const Color accentBlueDark = Color(0xFF7B2FD4);
  static const Color accentGold = Color(0xFFFFB800);
  static const Color accentPurple = Color(0xFF9945FF);
  static const Color emeraldGreen = Color(
    0xFF9945FF,
  ); // Unified Brand Purple Accent
  static const Color textMuted = Color(0xFF64748B);

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
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 16.sp,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Subscription',
          style: GoogleFonts.arimo(
            fontSize: 18.sp,
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
                color: accentBlue,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Header & Segmented Toggle Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Column(
                children: [
                  // Current Plan Header / Active Banner
                  _buildCurrentPlanIndicator(context),
                  SizedBox(height: 8.h),

                  // Hero Title Section (Only visible for Free Tier users)
                  Obx(() {
                    if (controller.currentPlanTier > 0) {
                      return SizedBox(height: 6.h);
                    }
                    return Column(
                      children: [
                        Text(
                          'Upgrade Your Plan',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arimo(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Unlock premium features and choose the plan that fits your needs.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.arimo(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: textMuted,
                              height: 1.3,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    );
                  }),

                  // Fixed Segmented Toggle (Monthly / Yearly)
                  _buildSegmentedToggle(context),
                ],
              ),
            ),

            // Scrollable Content (Plan Cards & Footer)
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
                          vertical: 8.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Animated Cards View (Only 2 Cards: Premium & Enterprise)
                            _buildSubscriptionCards(context),
                            Padding(
                              padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
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
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Current Plan Header / Active Plan Banner
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
            : 'July 28, 2026';

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9945FF), Color(0xFF6C36B2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9945FF).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tier == 2
                              ? Icons.diamond_rounded
                              : Icons.workspace_premium_rounded,
                          color: Colors.amber,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'ACTIVE SUBSCRIPTION',
                          style: GoogleFonts.arimo(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      sub.status.toUpperCase(),
                      style: GoogleFonts.arimo(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: emeraldGreen,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                '$planName ${isYearly ? "(YEARLY)" : "(MONTHLY)"}',
                style: GoogleFonts.arimo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 13.sp,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      'Renews on: $formattedDate',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.arimo(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: controller.manageSubscription,
                    child: Text(
                      'Manage',
                      style: GoogleFonts.arimo(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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

      // Default Free User Pill
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
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
                color: Colors.black,
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
  // 2. Segmented Toggle (Monthly vs Yearly)
  // ---------------------------------------------------------------------------
  Widget _buildSegmentedToggle(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: cardBorderDark),
      ),
      child: TabBar(
        controller: controller.tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(19.r),
          gradient: const LinearGradient(
            colors: [Color(0xFF9945FF), Color(0xFF7B2FD4)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: accentBlue.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: textMuted,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.arimo(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.arimo(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
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
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'Save 25%',
                    style: GoogleFonts.arimo(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
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
  // 3. Subscription Cards Display (Only 2 Cards: Premium & Enterprise)
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
          // Dynamic pricing or elegant fallbacks
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
              // Premium Card (Index 1)
              _buildPlanCard(
                context,
                planIndex: 1,
                title: 'Premium',
                price: premiumPrice,
                period: isYearly ? '/year' : '/month',
                subtitle: 'Essential power for surgical professionals',
                badgeText: 'Most Popular',
                badgeColor: accentBlue,
                iconData: Icons.workspace_premium_rounded,
                accentColor: accentBlue,
                features: const [
                  '20 Preference Cards',
                  'Calendar Sync & Public Library Access',
                  'Standard Search & Email Support',
                ],
                isSelected: controller.selectedPlan.value == 1,
                isCurrent: isPremiumCurrent,
                isDisabled: isPremiumDisabled,
                ctaText: isPremiumCurrent
                    ? 'Current Plan'
                    : (isPremiumDisabled
                          ? 'Plan Active'
                          : 'Get Premium'),
              ),
              SizedBox(height: 10.h),

              // Enterprise Card (Index 2)
              _buildPlanCard(
                context,
                planIndex: 2,
                title: 'Enterprise',
                price: enterprisePrice,
                period: isYearly ? '/year' : '/month',
                subtitle: 'Unlimited access & advanced team features',
                badgeText: 'Best Value',
                badgeColor: accentPurple,
                iconData: Icons.diamond_rounded,
                accentColor: accentPurple,
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
  // 4. Individual Plan Card Widget
  // ---------------------------------------------------------------------------
  Widget _buildPlanCard(
    BuildContext context, {
    required int planIndex,
    required String title,
    required String price,
    required String period,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required IconData iconData,
    required Color accentColor,
    required List<String> features,
    required bool isSelected,
    required bool isCurrent,
    required bool isDisabled,
    required String ctaText,
  }) {
    final borderColor = isCurrent
        ? emeraldGreen
        : (isSelected && !isDisabled ? accentColor : cardBorderDark);

    final cardWidget = GestureDetector(
      onTap: () => controller.selectPlan(planIndex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: cardDark,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: borderColor,
            width: (isSelected || isCurrent) ? 2.w : 1.w,
          ),
          boxShadow: isSelected && !isDisabled
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Badge & Icon Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(iconData, color: accentColor, size: 22.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.arimo(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.arimo(
                          fontSize: 11.sp,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                if (isCurrent)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: emeraldGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: emeraldGreen.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      'Current',
                      style: GoogleFonts.arimo(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: emeraldGreen,
                      ),
                    ),
                  )
                else if (isDisabled)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Lower Tier',
                      style: GoogleFonts.arimo(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [badgeColor, badgeColor.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      badgeText,
                      style: GoogleFonts.arimo(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10.h),

            // Price Display
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      price,
                      style: GoogleFonts.arimo(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  period,
                  style: GoogleFonts.arimo(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Container(height: 1.h, color: cardBorderDark),
            SizedBox(height: 8.h),

            // Feature Bullets
            ...features.map(
              (feature) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: emeraldGreen.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: emeraldGreen,
                        size: 13.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        feature,
                        style: GoogleFonts.arimo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // CTA Button
            SizedBox(
              width: double.infinity,
              height: 42.h,
              child: ElevatedButton(
                onPressed: (isCurrent || isDisabled)
                    ? null
                    : () {
                        controller.selectPlan(planIndex);
                        controller.subscribe();
                      },
                style:
                    ElevatedButton.styleFrom(
                      elevation: isSelected && !isDisabled ? 6 : 0,
                      shadowColor: accentColor.withValues(alpha: 0.4),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      backgroundColor: Colors.transparent,
                      disabledBackgroundColor: const Color(0xFFF1F5F9),
                    ).copyWith(
                      elevation: WidgetStateProperty.resolveWith(
                        (states) =>
                            states.contains(WidgetState.disabled) ? 0 : 4,
                      ),
                    ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: (isCurrent || isDisabled)
                        ? null
                        : const LinearGradient(
                            colors: [Color(0xFF9945FF), Color(0xFF7B2FD4)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      ctaText,
                      style: GoogleFonts.arimo(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: (isCurrent || isDisabled)
                            ? textMuted
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return cardWidget;
  }

  // ---------------------------------------------------------------------------
  // 4. Footer Section (Security, Microcopy, Policy Links)
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
        SizedBox(height: 6.h),
        Text(
          'Auto-renews until canceled. Cancel anytime in store settings.',
          textAlign: TextAlign.center,
          style: GoogleFonts.arimo(
            fontSize: 11.sp,
            color: textMuted.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _launchLegalUrl('https://smrtscrub.app/terms'),
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
              onTap: () => _launchLegalUrl('https://smrtscrub.app/privacy'),
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
      ],
    );
  }

  void _launchLegalUrl(String url) {
    Helpers.info('Legal Link Tapped: $url');
  }
}
