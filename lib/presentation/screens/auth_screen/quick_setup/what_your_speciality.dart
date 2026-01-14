import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../routes/routes.dart';

class WhatYourSpeciality extends StatelessWidget {
  WhatYourSpeciality({super.key});

  final selectedIndex = (-1).obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              Text(
                "What's Your Speciality?",
                style: GoogleFonts.arimo(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff101828),
                ),
              ),

              SizedBox(height: 6.h),

              Text(
                "This helps us pre load relevant terminology",
                style: GoogleFonts.arimo(
                  fontSize: 16.sp,
                  color: const Color(0xff4A5565),
                ),
              ),

              SizedBox(height: 20.h),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: specialties.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.7,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      selectedIndex.value = index;
                      Get.toNamed(RoutePages.preferredNoteMethod);
                    },
                    child: Obx(
                          () => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: selectedIndex.value == index
                                ? AppColors.primary
                                : const Color(0xffE5E5EA),
                            width: selectedIndex.value == index ? 2 : 1,
                          ),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(8.0.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: .min,
                            children: [
                              Text(
                                specialties[index].icon,
                                style: TextStyle(fontSize: 22.sp),
                              ),

                              const Spacer(),

                              Text(
                                specialties[index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.arimo(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
class SpecialtyItem {
  final String title;
  final String icon;

  SpecialtyItem(this.title, this.icon);
}

final specialties = [
  SpecialtyItem('Orthopedic Surgery', '🦴'),
  SpecialtyItem('Cardiac Surgery', '❤️'),
  SpecialtyItem('General Surgery', '🏥'),
  SpecialtyItem('Neurosurgery', '🧠'),
  SpecialtyItem('Plastic Surgery', '✨'),
  SpecialtyItem('Vascular Surgery', '🩸'),
  SpecialtyItem('Thoracic Surgery', '🫁'),
  SpecialtyItem('Pediatric Surgery', '👶'),
];
