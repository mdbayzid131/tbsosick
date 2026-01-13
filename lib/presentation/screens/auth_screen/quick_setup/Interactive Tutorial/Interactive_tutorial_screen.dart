import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/Interactive%20Tutorial/step_create_card3.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/Interactive%20Tutorial/step_create_card4.dart' hide StepCreateCard3;
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../controllers/tutorial_controller.dart';
import 'StepCreateCard1.dart';
import 'StepCreateCard2.dart';

class InteractiveTutorialScreen extends StatelessWidget {
  InteractiveTutorialScreen({super.key});

  final controller = Get.put(TutorialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xff9945FF).withOpacity(.10),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _Header(),

              _Progress(),

              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    StepCreateCard1(),
                    StepCreateCard2(),
                    StepCreateCard3(),
                    StepCreateCard4(),

                    // _StepLogMoments(),
                    // _StepVoiceNotes(),
                    // _StepReview(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _Header() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Row(
      children: [
        Container(
          height: 48.w,
          width: 48.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.auto_fix_high, color: Colors.white, size: 18),
        ),
        SizedBox(width: 10),
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
              margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
              height: 6.sp,
              decoration: BoxDecoration(
                color: controller.currentStep.value >= index
                    ? Color(0xff9945FF)
                    : Color(0xffE5E7EB),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          );
        }),
      ),
    ),
  );
}

Widget _stepItem(String number, String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: Color(0xffF7F7FB),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      children: [
        Container(
          height: 32.w,
          width: 32.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.arimo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: Text(
            text,
            style: GoogleFonts.arimo(fontSize: 14.sp, color: Color(0xff364153)),
          ),
        ),
      ],
    ),
  );
}
