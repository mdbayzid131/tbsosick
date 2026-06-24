import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';
import 'package:tbsosick/l10n/app_localizations.dart';
import 'package:tbsosick/core/services/auth_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/presentation/widgets/custom_text_field.dart';

// GetX Controller for managing privacy settings state
class PrivacySettingsController extends GetxController {
  // Observable variables
  RxBool shareData = true.obs;
  RxBool emailNotifications = true.obs;
  RxBool pushNotifications = true.obs;
}

/// Backwards compatibility helper.
/// Automatically routes any callers of the old bottom sheet directly to the new Page.
void showPrivacyAndSecurityBottomSheet(BuildContext context) {
  Get.to(() => const PrivacyAndSecurityPage());
}

class PrivacyAndSecurityPage extends StatefulWidget {
  const PrivacyAndSecurityPage({super.key});

  @override
  State<PrivacyAndSecurityPage> createState() => _PrivacyAndSecurityPageState();
}

class _PrivacyAndSecurityPageState extends State<PrivacyAndSecurityPage> {
  late final PrivacySettingsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PrivacySettingsController());
  }

  @override
  void dispose() {
    Get.delete<PrivacySettingsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C36B2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          tr.privacyAndSecurity,
          style: GoogleFonts.arimo(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Security Settings Section
              Text(
                "SECURITY",
                style: GoogleFonts.arimo(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9CA3AF),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: _buildMenuItem(
                  icon: Icons.vpn_key_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  title: "Change Password",
                  subtitle: "Update your password to keep your account secure",
                  onTap: () {
                    Get.to(() => const ChangePasswordPage());
                  },
                ),
              ),

              SizedBox(height: 28.h),

              // // Preferences settings section
              // Text(
              //   tr.preferences.toUpperCase(),
              //   style: GoogleFonts.arimo(
              //     fontSize: 12.sp,
              //     fontWeight: FontWeight.w600,
              //     color: const Color(0xFF9CA3AF),
              //     letterSpacing: 0.5,
              //   ),
              // ),
              // SizedBox(height: 12.h),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(16.r),
              //     border: Border.all(
              //       color: const Color(0xFFE5E7EB),
              //       width: 1.w,
              //     ),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withValues(alpha: 0.04),
              //         blurRadius: 8.r,
              //         offset: Offset(0, 2.h),
              //       ),
              //     ],
              //   ),
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(
              //       horizontal: 16.w,
              //       vertical: 20.h,
              //     ),
              //     child: Column(
              //       children: [
              //         // Share Data option
              //         // Obx(
              //         //   () => _buildSettingItem(
              //         //     icon: Icons.lock_outline,
              //         //     title: tr.shareData,
              //         //     description: tr.shareDataDesc,
              //         //     value: controller.shareData.value,
              //         //     onChanged: (value) {
              //         //       controller.shareData.value = value;
              //         //     },
              //         //   ),
              //         // ),

              //         // Divider(height: 32.h, color: const Color(0xFFF3F4F6)),

              //         // // Email Notifications option
              //         // Obx(
              //         //   () => _buildSettingItem(
              //         //     icon: Icons.notifications_outlined,
              //         //     title: tr.emailNotifications,
              //         //     description: tr.emailNotificationsDesc,
              //         //     value: controller.emailNotifications.value,
              //         //     onChanged: (value) {
              //         //       controller.emailNotifications.value = value;
              //         //     },
              //         //   ),
              //         // ),

              //         // Divider(height: 32.h, color: const Color(0xFFF3F4F6)),

              //         // // Push Notifications option
              //         // Obx(
              //         //   () => _buildSettingItem(
              //         //     icon: Icons.notifications_outlined,
              //         //     title: tr.pushNotifications,
              //         //     description: tr.pushNotificationsDesc,
              //         //     value: controller.pushNotifications.value,
              //         //     onChanged: (value) {
              //         //       controller.pushNotifications.value = value;
              //         //     },
              //         //   ),
              //         // ),
              //       ],
              //     ),
              //   ),
              // ),

              // SizedBox(height: 36.h),

              // // Save button
              // SizedBox(
              //   width: double.infinity,
              //   child: CustomElevatedButton(
              //     onPressed: () {
              //       Helpers.showSuccess("Settings saved successfully!");
              //       Get.back();
              //     },
              //     label: tr.saveChanges,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Setting item list item
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F0FF),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1C1B1F),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.arimo(
                      fontSize: 13.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFF9CA3AF),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  // Setting item switch widget
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
          child: Icon(icon, size: 24.sp, color: const Color(0xFF1C1B1F)),
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
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: GoogleFonts.arimo(
                  fontSize: 13.sp,
                  color: const Color(0xFF9CA3AF),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 12.w),

        // Checkmark circle (tbsosick visual style)
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: value ? const Color(0xFF3B82F6) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: value
                    ? const Color(0xFF0A7AFF)
                    : const Color(0xFFD1D5DB),
                width: 2.w,
              ),
            ),
            child: value
                ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                : null,
          ),
        ),
      ],
    );
  }
}

// GetX Controller for managing Change Password state & actions
class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscureCurrent = true.obs;
  final obscureNew = true.obs;
  final obscureConfirm = true.obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> submitChangePassword() async {
    if (!formKey.currentState!.validate()) return;

    Helpers.hideKeyboard();
    Helpers.showLoadingDialog(message: "Updating password...");

    try {
      final authService = Get.find<AuthService>();
      await authService.changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      Helpers.hideLoadingDialog();
      Helpers.showSuccess("Password changed successfully!");

      // Close the Change Password screen
      Get.back();
    } catch (e) {
      Helpers.hideLoadingDialog();
      String errMsg =
          "Failed to change password. Please check your current password.";

      // Dynamic robust exception parsing for any Dio/Network exception structures
      try {
        if (e.runtimeType.toString().contains("DioException") ||
            e.runtimeType.toString().contains("DioError")) {
          final dynamic errorObj = e;
          if (errorObj.response?.data != null) {
            final data = errorObj.response.data;
            if (data is Map) {
              errMsg = data['message'] ?? data['error'] ?? errMsg;
            } else if (data is String) {
              errMsg = data;
            }
          } else if (errorObj.message != null) {
            errMsg = errorObj.message;
          }
        } else {
          final dynamic err = e;
          errMsg = err.message ?? err.toString();
        }
      } catch (_) {
        errMsg = e.toString();
      }

      Helpers.showError(errMsg);
    }
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final ChangePasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChangePasswordController());
  }

  @override
  void dispose() {
    Get.delete<ChangePasswordController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C36B2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Change Password",
          style: GoogleFonts.arimo(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create a New Password",
                  style: GoogleFonts.arimo(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1C1B1F),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Your new password must be different from previously used passwords.",
                  style: GoogleFonts.arimo(
                    fontSize: 14.sp,
                    color: const Color(0xFF9CA3AF),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 28.h),

                // Current Password Input
                Obx(
                  () => CustomTextField(
                    controller: controller.currentPasswordController,
                    hintText: "Enter current password",
                    label: "Current Password",
                    obscureText: controller.obscureCurrent.value,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF8B5CF6),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureCurrent.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9CA3AF),
                      ),
                      onPressed: () => controller.obscureCurrent.toggle(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Current password is required";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20.h),

                // New Password Input
                Obx(
                  () => CustomTextField(
                    controller: controller.newPasswordController,
                    hintText: "Enter new password",
                    label: "New Password",
                    obscureText: controller.obscureNew.value,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF8B5CF6),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureNew.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9CA3AF),
                      ),
                      onPressed: () => controller.obscureNew.toggle(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "New password is required";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters long";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20.h),

                // Confirm Password Input
                Obx(
                  () => CustomTextField(
                    controller: controller.confirmPasswordController,
                    hintText: "Re-enter new password",
                    label: "Confirm Password",
                    obscureText: controller.obscureConfirm.value,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF8B5CF6),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureConfirm.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9CA3AF),
                      ),
                      onPressed: () => controller.obscureConfirm.toggle(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != controller.newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 36.h),

                // Update Password Button
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: controller.submitChangePassword,
                    label: "Update Password",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
