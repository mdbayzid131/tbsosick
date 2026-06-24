import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

class PreferredNoteMethod extends StatelessWidget {
  const PreferredNoteMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F7),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () => Get.back(),
            ),
            SizedBox(height: 15.h),

            Text(
              tr.noteMethodQuestion,
              style: GoogleFonts.arimo(
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff101828),
              ),
            ),

            SizedBox(height: 6.h),

            Text(
              tr.chooseInputMethod,
              style: GoogleFonts.arimo(
                fontSize: 16.sp,
                color: const Color(0xff4A5565),
              ),
            ),

            SizedBox(height: 20.h),

            Column(
              children: [
                _optionTile(
                  icon: Icons.mic_outlined,
                  iconBg: Color(0xff2F6BFF),
                  title: tr.voiceToText,
                  subtitle: tr.voiceToTextDesc,
                  onTap: () {
                    Get.toNamed(AppRoutes.interactiveTutorial);
                  },
                ),

                SizedBox(height: 12.h),

                _optionTile(
                  icon: Icons.chevron_right,
                  iconBg: Color(0xff8E44FF),
                  title: tr.rapidChecklist,
                  subtitle: tr.rapidChecklistDesc,
                  onTap: () {
                    Get.toNamed(AppRoutes.interactiveTutorial);
                  },
                ),

                SizedBox(height: 12.h),

                _optionTile(
                  icon: Icons.person_outline,
                  iconBg: Color(0xff00C853),
                  title: tr.freehandEntry,
                  subtitle: tr.freehandEntryDesc,
                  onTap: () {
                    Get.toNamed(AppRoutes.interactiveTutorial);
                  },
                ),
              ],
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

Widget _optionTile({
  required IconData icon,
  required Color iconBg,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(16.r),
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xffE5E5EA)),
      ),
      child: Row(
        children: [
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Colors.white, size: 22.sp),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.arimo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.arimo(
                    fontSize: 13.sp,
                    color: Color(0xff8E8E93),
                  ),
                ),
              ],
            ),
          ),

          Icon(Icons.chevron_right, color: Color(0xffC7C7CC), size: 22.sp),
        ],
      ),
    ),
  );
}
