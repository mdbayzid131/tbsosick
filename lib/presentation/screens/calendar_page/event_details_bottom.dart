import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void showEventDetailsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - Event Details title with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Event Details',
                      style: GoogleFonts.arimo(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF000000),
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
                        child: Icon(
                          Icons.close,
                          size: 20.sp,
                          color: const Color(0xFF1C1B1F),
                        ),
                      ),
                    ),
                  ],
                ),
          
                SizedBox(height: 24.h),
          
                // Event title
                Text(
                  'Total Knee Replacement',
                  style: GoogleFonts.arimo(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                  ),
                ),
          
                SizedBox(height: 16.h),
          
                // Date and time
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 20.sp,
                      color: const Color(0xff8E8E93),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'January 8, 2026 at 08:00',
                      style: GoogleFonts.arimo(
                        fontSize: 15.sp,
                        color: const Color(0xff8E8E93),
                      ),
                    ),
                  ],
                ),
          
                SizedBox(height: 16.h),
          
                // Location section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20.sp,
                      color: const Color(0xff8E8E93),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: GoogleFonts.arimo(
                            fontSize: 14.sp,
                            color: const Color(0xff8E8E93),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'OR 3',
                          style: GoogleFonts.arimo(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          
                SizedBox(height: 16.h),
          
                // Preference Card section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 20.sp,
                      color: const Color(0xff8E8E93),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preference Card',
                            style: GoogleFonts.arimo(
                              fontSize: 14.sp,
                              color: const Color(0xff8E8E93),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Dr. Sarah Johnson — Total Knee Replacement',
                            style: GoogleFonts.arimo(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFf9945FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          
                SizedBox(height: 20.h),
          
                // Notes section
                Text(
                  'Notes',
                  style: GoogleFonts.arimo(
                    fontSize: 14.sp,
                    color: const Color(0xff8E8E93),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Patient: John Smith, 65y/o',
                  style: GoogleFonts.arimo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1C1B1F),
                  ),
                ),
          
                SizedBox(height: 24.h),
          
                // Action buttons - Delete and Edit
                Row(
                  children: [
                    // Delete button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Delete event functionality
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3B30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Delete',
                              style: GoogleFonts.arimo(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Edit button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Edit event functionality
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9945FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Edit',
                              style: GoogleFonts.arimo(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      );
    },
  );
}