import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';

// GetX Controller for managing state
class PrivacySettingsController extends GetxController {
  // Observable variables
  RxBool shareData = true.obs;
  RxBool emailNotifications = true.obs;
  RxBool pushNotifications = true.obs;
}

void showPrivacyAndSecurityBottomSheet(BuildContext context) {
  // Initialize controller
  final controller = Get.put(PrivacySettingsController());

  showModalBottomSheet(
    isDismissible: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privacy & Security',
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

              // Share Data option
              Obx(() => _buildSettingItem(
                icon: Icons.lock_outline,
                title: 'Share Data',
                description:
                'Allow SMRTSCRUB to share your data with third parties.',
                value: controller.shareData.value,
                onChanged: (value) {
                  controller.shareData.value = value;
                },
              )),

              SizedBox(height: 16.h),

              // Email Notifications option
              Obx(() => _buildSettingItem(
                icon: Icons.notifications_outlined,
                title: 'Email Notifications',
                description: 'Receive notifications via email.',
                value: controller.emailNotifications.value,
                onChanged: (value) {
                  controller.emailNotifications.value = value;
                },
              )),

              SizedBox(height: 16.h),

              // Push Notifications option
              Obx(() => _buildSettingItem(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                description: 'Receive notifications on your device.',
                value: controller.pushNotifications.value,
                onChanged: (value) {
                  controller.pushNotifications.value = value;
                },
              )),

              SizedBox(height: 24.h),

              // Save button
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: () {
                    // TODO: Save settings
                    Get.back();
                  },
                   label: 'Save Changes',
                ),
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {
    // Clean up controller when bottom sheet closes
    Get.delete<PrivacySettingsController>();
  });
}

// Setting item widget
Widget _buildSettingItem({
  required IconData icon,
  required String title,
  required String description,
  required bool value,
  required Function(bool) onChanged,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Icon
      Container(
        width: 24.w,
        height: 24.h,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 24.sp,
          color: const Color(0xFF1C1B1F),
        ),
      ),

      SizedBox(width: 16.w),

      // Title and description
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.arimo(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1B1F),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              style: GoogleFonts.arimo(
                fontSize: 14.sp,
                color: const Color(0xFF9CA3AF),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),

      SizedBox(width: 12.w),

      // Checkmark circle
      GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: value ? const Color(0xFF3B82F6) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: value ? const Color(0xFF0A7AFF) : const Color(0xFFD1D5DB),
              width: 2.w,
            ),
          ),
          child: value
              ? Icon(
            Icons.check,
            color: Colors.white,
            size: 18.sp,
          )
              : null,
        ),
      ),
    ],
  );
}