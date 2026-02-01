import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/Interactive%20Tutorial/step_create_card3.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/Interactive%20Tutorial/step_create_card4.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../controllers/tutorial_controller.dart';
import 'StepCreateCard1.dart';
import 'StepCreateCard2.dart';

class InteractiveTutorialScreen extends StatelessWidget {
  InteractiveTutorialScreen({super.key});

  final controller = Get.put(TutorialController());

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

Widget _Header() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
    child: Row(
      children: [
        /// 🔹 Circular icon container
        Container(
          height: 48.w,
          width: 48.w,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child:  Icon(Icons.auto_fix_high, color: Colors.white, size: 18.sp),
        ),

        SizedBox(width: 10.w),

        /// 🔹 Title & subtitle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interactive Tutorial',
              style: GoogleFonts.arimo(
                color: AppColors.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '30 seconds to master',
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

Widget _Progress() {
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
