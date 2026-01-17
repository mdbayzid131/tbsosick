import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_color.dart';
import '../../../core/constants/image_paths.dart';

void showNotificationBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Notifications',
                      style: GoogleFonts.arimo(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff1C1B1F),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Mark all read',
                        style: GoogleFonts.arimo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Container(
                        height: 32.w,
                        width: 32.w,
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F7),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header


                        SizedBox(height: 16.h),

                        // Notification card 1
                        _notificationCard(
                          icon: Icons.assignment_outlined,
                          title: 'New Card Added',
                          subtitle: 'Dr. Sarah Johnson — Total\nKnee Replacement',
                          actionText: 'View Card',
                          time: '16m ago',
                        ),

                        SizedBox(height: 12.h),

                        // Notification card 2
                        _notificationCard(
                          icon: Icons.calendar_today_outlined,
                          title: 'Event Scheduled',
                          subtitle: 'Total Knee Replacement on\n2026-01-08 at 08:00',
                          actionText: 'View Event',
                          time: '16m ago',
                        ),
                        SizedBox(height: 12.h),

                        // Notification card 2
                        _notificationCard(
                          icon: Icons.calendar_today_outlined,
                          title: 'Event Scheduled',
                          subtitle: 'Total Knee Replacement on\n2026-01-08 at 08:00',
                          actionText: 'View Event',
                          time: '16m ago',
                        ),
                        SizedBox(height: 12.h),

                        // Notification card 2
                        _notificationCard(
                          icon: Icons.calendar_today_outlined,
                          title: 'Event Scheduled',
                          subtitle: 'Total Knee Replacement on\n2026-01-08 at 08:00',
                          actionText: 'View Event',
                          time: '16m ago',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _notificationCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required String actionText,
  required String time,
}) {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: const Color(0xffF4EEFF),
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                color: Color(0xffE8DEF8),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: Color(0xff6750A4), size: 20.sp),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.arimo(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.arimo(
                      fontSize: 15.sp,
                      color: const Color(0xff8E8E93),
                    ),
                  ),
                ],
              ),
            ),

            Text(
              time,
              style: GoogleFonts.arimo(
                fontSize: 13.sp,
                color: const Color(0xff8E8E93),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                actionText,
                style: GoogleFonts.arimo(
                  fontSize: 15.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                ImagePaths.deleteIcon,
                width: 20.w,
                height: 20.w,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
