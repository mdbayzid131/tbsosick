import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';
import 'package:tbsosick/l10n/app_localizations.dart';
import 'package:tbsosick/core/services/iap_service.dart';
import 'package:tbsosick/presentation/screens/ProfilePage/controller/subscription_controller.dart';
import '../../../../config/constants/image_paths.dart';

class SelectPackageScreen extends GetView<SubscriptionController> {
  const SelectPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Resolve or retrieve SubscriptionController
    final controller = Get.isRegistered<SubscriptionController>()
        ? Get.find<SubscriptionController>()
        : Get.put(SubscriptionController());

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
            // Purple Gradient Header Banner (App Logo, Unlock text, subtitle)
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
                      color: Colors.white.withValues(alpha: .20),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28.w),
                      child: Image.asset(
                        ImagePaths.appLogo,
                        fit: BoxFit.cover,
                      ),
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
                      color: Colors.white.withValues(alpha: .9),
                    ),
                  ),
                ],
              ),
            ),

            // Pill-shaped TabBar for switching between Monthly/Yearly plans
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

            // Scrollable TabBarView for Plan List options
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildPlanList(
                    context,
                    controller,
                    controller.monthlyProducts,
                    isYearly: false,
                  ),
                  _buildPlanList(
                    context,
                    controller,
                    controller.yearlyProducts,
                    isYearly: true,
                  ),
                ],
              ),
            ),

            // Bottom Action Button with onboarding logic
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Obx(
                () => CustomElevatedButton(
                  isLoading: controller.isLoading,
                  label: controller.isSelectedPlanCurrent
                      ? 'Continue'
                      : (controller.selectedPlan.value == 0
                          ? tr.continueWithFree
                          : (controller.selectedPlan.value == 1
                              ? tr.continueWithPremium
                              : tr.continueWithEnterprise)),
                  onPressed: () async {
                    if (controller.isSelectedPlanCurrent || controller.selectedPlan.value == 0) {
                      // Free plan or currently active plan - directly proceed to next onboarding step
                      Get.toNamed(AppRoutes.whatYourSpeciality);
                    } else {
                      // Try to subscribe to the paid plan
                      await controller.subscribe();
                      // Once successfully subscribed and confirmed, proceed to next step
                      if (controller.isSelectedPlanCurrent && !controller.isLoading) {
                        Get.toNamed(AppRoutes.whatYourSpeciality);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Plan List helper
Widget _buildPlanList(
  BuildContext context,
  SubscriptionController controller,
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
              context: context,
              title: tr.freePlanTitle,
              price: '\$0',
              period: '',
              features: [
                tr.featureBasicCards,
                tr.featureNoLibrary,
                tr.featureNoCalendar,
                tr.featureEmailSupport,
              ],
              isSelected: controller.selectedPlan.value == 0,
              currentPlan: controller.currentSubscription?.plan == 'FREE',
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Paid Plans list
        Obx(() {
          if (products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: products.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;

              final isPremium = index == 0;
              final planIndex = isPremium ? 1 : 2;

              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: GestureDetector(
                  onTap: () => controller.selectPlan(planIndex),
                  child: _planCard(
                    context: context,
                    title: isPremium
                        ? tr.premiumPlanTitle
                        : tr.enterprisePlanTitle,
                    price: product.price,
                    period: isYearly ? '/year' : tr.monthLabel,
                    badge: isPremium ? tr.popularBadge : null,
                    features: isPremium
                        ? [
                            tr.featurePremiumCards,
                            tr.featureBasicCalendar,
                            tr.featurePublicLibrary,
                            tr.featureNoCollaboration,
                            tr.featureNoVerifiedCard,
                          ]
                        : [
                            tr.featureUnlimitedCards,
                            tr.featureAdvancedCalendar,
                            tr.featurePublicLibrary,
                            tr.featureTeamCollaboration,
                            tr.featureVerifiedCards,
                          ],
                    isSelected: controller.selectedPlan.value == planIndex,
                    currentPlan:
                        (isPremium
                            ? controller.currentSubscription?.plan ==
                                  'PREMIUM'
                            : controller.currentSubscription?.plan ==
                                  'ENTERPRISE') &&
                        (controller.currentSubscription?.productId?.contains(
                              isYearly ? 'yearly' : 'monthly',
                            ) ??
                            true),
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

// Plan Card styling layout
Widget _planCard({
  required BuildContext context,
  required String title,
  required String price,
  required String period,
  required List<String> features,
  bool isSelected = false,
  bool currentPlan = false,
  String? badge,
}) {
  final tr = AppLocalizations.of(context)!;
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isSelected
          ? AppTheme.primaryColor.withValues(alpha: 0.05)
          : Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isSelected ? AppTheme.primaryColor : const Color(0xffC6C6C8),
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
                  color: const Color(0xff14F195),
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
            const Spacer(),
            if (currentPlan)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
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
