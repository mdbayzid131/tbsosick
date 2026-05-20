import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/core/controllers/language_controller.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

void showLanguageBottomSheet(BuildContext context) {
  final LanguageController languageController = Get.find<LanguageController>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.selectLanguage,
                    style: GoogleFonts.arimo(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1C1B1F),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 32.h,
                      width: 32.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2F2F7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Language Options
              Obx(
                () => Column(
                  children: [
                    _buildLanguageItem(
                      context: context,
                      title: AppLocalizations.of(context)!.english,
                      isSelected:
                          languageController.locale.value.languageCode == 'en',
                      onTap: () {
                        languageController.changeLanguage('en');
                        Get.back();
                      },
                    ),
                    _buildLanguageItem(
                      context: context,
                      title: AppLocalizations.of(context)!.spanish,
                      isSelected:
                          languageController.locale.value.languageCode == 'es',
                      onTap: () {
                        languageController.changeLanguage('es');
                        Get.back();
                      },
                    ),
                    _buildLanguageItem(
                      context: context,
                      title: AppLocalizations.of(context)!.german,
                      isSelected:
                          languageController.locale.value.languageCode == 'de',
                      onTap: () {
                        languageController.changeLanguage('de');
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildLanguageItem({
  required BuildContext context,
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.arimo(
              fontSize: 18.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF6750A4)
                  : const Color(0xFF1C1B1F),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: const Color(0xFF6750A4),
              size: 24.sp,
            ),
        ],
      ),
    ),
  );
}
