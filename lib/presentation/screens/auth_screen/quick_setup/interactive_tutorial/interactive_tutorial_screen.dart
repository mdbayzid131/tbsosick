import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/interactive_tutorial/step_create_card3.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/interactive_tutorial/step_create_card4.dart';
import 'package:tbsosick/l10n/app_localizations.dart';
import '../../../../controllers/tutorial_controller.dart';
import 'step_create_card1.dart';
import 'step_create_card2.dart';

class InteractiveTutorialScreen extends StatelessWidget {
  InteractiveTutorialScreen({super.key});

  final controller = Get.find<TutorialController>();

  @override
  Widget build(BuildContext context) {
    // 🔹 System top safe area (status bar / notch height)
    final double topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff9945FF).withValues(alpha: .1), Colors.white],
            ),
          ),
          child: Column(
            children: [
              /// 🔹 Manual safe-area spacer
              /// This prevents UI from going under status bar / notch
              SizedBox(height: topInset),

              /// 🔹 Header section (fixed height – responsive padding inside)
              _Header(),

              /// 🔹 Progress indicator
              _Progress(),

              /// 🔹 Main tutorial pages
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StepCreateCard1(),
                    StepCreateCard2(),
                    StepCreateCard3(),
                    StepCreateCard4(),
                  ],
                ),
              ),

              /// 🔹 Bottom spacing
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          /// 🔹 Circular icon container
          Container(
            height: 48.w,
            width: 48.w,
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_fix_high, color: Colors.white, size: 18.sp),
          ),

          SizedBox(width: 10.w),

          /// 🔹 Title & subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr.interactiveTutorial,
                style: GoogleFonts.arimo(
                  color: AppTheme.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                tr.tutorialTime,
                style: GoogleFonts.arimo(
                  fontSize: 12.sp,
                  color: Color(0xff4A5565),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TutorialController>();

    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index == 3 ? 0 : 6.w),
                height: 6.h,
                decoration: BoxDecoration(
                  color: controller.currentStep.value >= index
                      ? const Color(0xff9945FF)
                      : const Color(0xffE5E7EB),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
