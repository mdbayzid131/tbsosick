import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/notification_model.dart';
import 'package:tbsosick/presentation/controllers/notification_controller.dart';
import 'package:tbsosick/config/routes/app_pages.dart';

import '../../../config/constants/image_paths.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

void showNotificationBottomSheet(BuildContext context) {
  final controller = Get.find<NotificationController>();
  controller.fetchNotifications(isRefresh: true);

  showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final tr = AppLocalizations.of(context)!;
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
                      tr.notifications,
                      style: GoogleFonts.arimo(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff1C1B1F),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => controller.markAllAsRead(),
                      child: Text(
                        tr.markAllRead,
                        style: GoogleFonts.arimo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryColor,
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
                        decoration: const BoxDecoration(
                          color: Color(0xffF2F2F7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.notifications.isEmpty) {
                      return Center(
                        child: Text(
                          'No notifications',
                          style: GoogleFonts.arimo(
                            fontSize: 16.sp,
                            color: const Color(0xff8E8E93),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.only(top: 16.h, bottom: 20.h),
                      itemCount: controller.notifications.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final notification = controller.notifications[index];
                        return _notificationCard(
                          context,
                          notification: notification,
                          onReadTap: () =>
                              controller.markAsRead(notification.id),
                          onDeleteTap: () =>
                              controller.deleteNotification(notification.id),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _notificationCard(
  BuildContext context, {
  required NotificationModel notification,
  required VoidCallback onReadTap,
  required VoidCallback onDeleteTap,
}) {
  final tr = AppLocalizations.of(context)!;

  IconData iconData;
  switch (notification.icon) {
    case 'card':
      iconData = Icons.assignment_outlined;
      break;
    case 'event':
      iconData = Icons.calendar_today_outlined;
      break;
    default:
      iconData = Icons.notifications_none_rounded;
  }

  return InkWell(
    onTap: notification.isRead ? null : onReadTap,
    child: Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.grey.shade50 : const Color(0xffF4EEFF),
        borderRadius: BorderRadius.circular(16.r),
        border: notification.isRead 
            ? Border.all(color: Colors.grey.shade200) 
            : null,
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
                  color: notification.isRead ? Colors.grey.shade200 : const Color(0xffE8DEF8),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(iconData, 
                  color: notification.isRead ? Colors.grey : const Color(0xff6750A4), 
                  size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: GoogleFonts.arimo(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: notification.isRead ? Colors.grey.shade700 : Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.subtitle,
                      style: GoogleFonts.arimo(
                        fontSize: 15.sp,
                        color: const Color(0xff8E8E93),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                Helpers.timeAgo(notification.createdAt),
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
                onPressed: () {
                  if (!notification.isRead) {
                    onReadTap();
                  }
                  
                  if (notification.resourceType == 'PreferenceCard') {
                    Get.toNamed(AppRoutes.cardDetails, arguments: {
                      'cardId': notification.resourceId,
                    });
                  } else if (notification.resourceType == 'Event') {
                    // Navigate to event details if route exists
                    // Get.toNamed(AppRoutes.EVENT_DETAILS, arguments: notification.resourceId);
                  }
                },
                child: Text(
                  notification.link?.label ?? (notification.resourceType == 'PreferenceCard' ? tr.viewCard : tr.viewEvent),
                  style: GoogleFonts.arimo(
                    fontSize: 15.sp,
                    color: notification.isRead ? Colors.grey : AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showDeleteConfirmation(context, onDeleteTap),
                icon: SvgPicture.asset(
                  ImagePaths.deleteIcon,
                  width: 20.w,
                  height: 20.w,
                  colorFilter: notification.isRead 
                      ? const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _showDeleteConfirmation(BuildContext context, VoidCallback onDelete) {
  final tr = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(tr.delete),
      content: const Text('Are you sure you want to delete this notification?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(tr.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
          child: Text(tr.delete, style: const TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

