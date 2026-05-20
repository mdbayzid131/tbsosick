import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/l10n/app_localizations.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/controller/specialty_controller.dart';

class WhatYourSpeciality extends StatelessWidget {
  WhatYourSpeciality({super.key});

  final SpecialtyController controller = Get.put(SpecialtyController());

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F7),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
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
                  color: const Color(0xff101828),
                ),
              ),
              SizedBox(height: 20.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.specialties.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.7,
                ),
                itemBuilder: (context, index) {
                  final specialty = controller.specialties[index];
                  return GestureDetector(
                    onTap: () {
                      controller.selectSpecialty(index);
                      Get.toNamed(AppRoutes.preferredNoteMethod);
                    },
                    child: Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: controller.selectedIndex.value == index
                                ? AppTheme.primaryColor
                                : const Color(0xffE5E5EA),
                            width: controller.selectedIndex.value == index
                                ? 2
                                : 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _getIconForSpecialty(specialty.name),
                                style: TextStyle(fontSize: 22.sp),
                              ),
                              const Spacer(),
                              Text(
                                specialty.name,
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
        );
      }),
    );
  }

  String _getIconForSpecialty(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('orthopedic')) return '🦴';
    if (lowerName.contains('cardiac') || lowerName.contains('heart')) {
      return '❤️';
    }
    if (lowerName.contains('general')) return '🏥';
    if (lowerName.contains('neuro')) return '🧠';
    if (lowerName.contains('plastic')) return '✨';
    if (lowerName.contains('vascular')) return '🩸';
    if (lowerName.contains('thoracic') || lowerName.contains('lung')) {
      return '🫁';
    }
    if (lowerName.contains('pediatric') || lowerName.contains('child')) {
      return '👶';
    }
    return '🩺'; // Default icon
  }
}
