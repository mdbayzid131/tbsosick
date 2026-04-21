import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

class WhatYourSpeciality extends StatelessWidget {
  WhatYourSpeciality({super.key});

  final selectedIndex = (-1).obs;

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final specialtiesList = getSpecialties(context);

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F7),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 65.h),

            Text(
              tr.specialtyQuestion,
              style: GoogleFonts.arimo(
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff101828),
              ),
            ),

            SizedBox(height: 20.h),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: specialtiesList.length,
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
                    Get.toNamed(AppRoutes.PREFERRED_NOTE_METHOD);
                  },
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: selectedIndex.value == index
                              ? AppTheme.primaryColor
                              : const Color(0xffE5E5EA),
                          width: selectedIndex.value == index ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: .min,
                          children: [
                            Text(
                              specialtiesList[index].icon,
                              style: TextStyle(fontSize: 22.sp),
                            ),

                            const Spacer(),

                            Text(
                              specialtiesList[index].title,
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
    );
  }
}

class SpecialtyItem {
  final String title;
  final String icon;

  SpecialtyItem(this.title, this.icon);
}

List<SpecialtyItem> getSpecialties(BuildContext context) {
  final tr = AppLocalizations.of(context)!;
  return [
    SpecialtyItem(tr.orthopedicSurgery, '🦴'),
    SpecialtyItem(tr.cardiacSurgery, '❤️'),
    SpecialtyItem(tr.generalSurgery, '🏥'),
    SpecialtyItem(tr.neurosurgery, '🧠'),
    SpecialtyItem(tr.plasticSurgery, '✨'),
    SpecialtyItem(tr.vascularSurgery, '🩸'),
    SpecialtyItem(tr.thoracicSurgery, '🫁'),
    SpecialtyItem(tr.pediatricSurgery, '👶'),
  ];
}
