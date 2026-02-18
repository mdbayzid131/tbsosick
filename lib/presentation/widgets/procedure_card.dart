import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/routes/app_pages.dart';

class ProcedureCard extends StatelessWidget {
  final bool isPrivateCard;
  final String cardId;
  final String title;
  final String specialty;
  final bool isVerified;
  final String doctor;
  final int downloads;
  final DateTime updatedTime;
  final bool isFavorite;
  final Future<void> Function()? onFavoriteToggle;
  final VoidCallback? onDownloadTap;

  const ProcedureCard({
    super.key,
    required this.isPrivateCard,
    required this.cardId,
    required this.title,
    required this.specialty,
    required this.isVerified,
    required this.doctor,
    required this.downloads,
    required this.updatedTime,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onDownloadTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: 
          () {
            Get.toNamed(AppRoutes.CARD_DETAILS, arguments: {'cardId': cardId});
          },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    height: 36.w,
                    width: 36.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8DEF8),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Icon(
                      isFavorite ? Icons.star : Icons.star_outline,
                      color:
                          isFavorite ? const Color(0xFFFFB800) : const Color(0xFF9CA3AF),
                      size: 22.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    specialty,
                    style: GoogleFonts.arimo(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6750A4),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                if (isVerified) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: const Color(0xFF10B981),
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Verified',
                          style: GoogleFonts.arimo(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              doctor,
              style: GoogleFonts.arimo(
                fontSize: 13.sp,
                color: const Color(0xFF79747E),
              ),
            ),
            SizedBox(height: 12.h),
            Divider(height: 1.5.h, color: const Color(0xFFE7E0EC)),
            SizedBox(height: 12.h),
            Row(
              children: [
                if (!isPrivateCard)
                  Icon(
                    Icons.file_download_outlined,
                    color: const Color(0xFF6B7280),
                    size: 20.sp,
                  ),
                SizedBox(width: 4.w),
                if (!isPrivateCard)
                  Text(
                    downloads.toString(),
                    style: GoogleFonts.arimo(
                      fontSize: 13.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                SizedBox(width: 16.w),
                Text(
                  "updated: ${updatedTime.day}/${updatedTime.month}/${updatedTime.year}",
                  style: GoogleFonts.arimo(
                    fontSize: 13.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onDownloadTap,
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6750A4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.file_download_outlined,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

