import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/constants/image_paths.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_time_picker.dart';

void showAddEventBottomSheet(BuildContext context) {
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final notesController = TextEditingController();

  final leadSurgeonController = TextEditingController();
  final teamMemberController = TextEditingController();

  List<String> teamMembers = ['Dr. Mike Chen', 'Nurse Amy Park'];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Event',
                        style: GoogleFonts.arimo(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: titleController,
                            label: 'Event Title *',
                            hintText: 'Enter event title',
                          ),

                          SizedBox(height: 12.h),

                          CustomDatePickerField(
                            controller: dateController,
                            label: 'Date *',
                            hintText: 'Select date',
                          ),

                          SizedBox(height: 12.h),

                          CustomTimePickerField(
                            controller: timeController,
                            label: 'Time *',
                            hintText: 'Select time',
                          ),

                          SizedBox(height: 16.h),

                          /// PERSONNEL CARD
                          _buildPersonnelCard(
                            leadSurgeonController: leadSurgeonController,
                            teamMemberController: teamMemberController,
                            teamMembers: teamMembers,
                            onAdd: () {
                              if (teamMemberController.text.isNotEmpty) {
                                setState(() {
                                  teamMembers.add(teamMemberController.text);
                                  teamMemberController.clear();
                                });
                              }
                            },
                            onRemove: (member) {
                              setState(() {
                                teamMembers.remove(member);
                              });
                            },
                          ),

                          SizedBox(height: 16.h),

                          CustomTextField(
                            controller: notesController,
                            label: 'Notes',
                            hintText: 'Additional notes...',
                            maxLines: 4,
                          ),

                          SizedBox(height: 24.h),

                          CustomElevatedButton(
                            label: 'Create Event',
                            onPressed: () {
                              // submit logic
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildPersonnelCard({
  required TextEditingController leadSurgeonController,
  required TextEditingController teamMemberController,
  required List<String> teamMembers,
  required VoidCallback onAdd,
  required Function(String) onRemove,
}) {
  return _buildCard(
    title: 'Personnel',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Lead Surgeon',
          controller: leadSurgeonController,
          icon: Icons.person_outline,
        ),

        SizedBox(height: 16.h),

        Text(
          'Surgical Team',
          style: GoogleFonts.arimo(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 8.h),

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: teamMemberController,
                hint: 'Add team member',
                showLabel: false,
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF6750A4),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.person_add_alt_outlined,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        ...teamMembers.map(
          (member) => ListTile(
            title: Text(member),
            trailing: IconButton(
              icon: SvgPicture.asset(
                ImagePaths.deleteIcon,
                height: 16.w,
                width: 16.w,
              ),
              onPressed: () => onRemove(member),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCard({
  required String title,
  required Widget child,
  IconData? titleIcon,
}) {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
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
            if (titleIcon != null) ...[
              Icon(titleIcon, size: 20.sp, color: const Color(0xFF1C1B1F)),
              SizedBox(width: 8.w),
            ],
            Text(
              title,
              style: GoogleFonts.arimo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1B1F),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        child,
      ],
    ),
  );
}

// Reusable TextField Widget
Widget _buildTextField({
  String? label,
  required TextEditingController controller,
  String? hint,
  IconData? icon,
  int maxLines = 1,
  bool readOnly = false,
  VoidCallback? onTap,
  bool showLabel = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (showLabel && (label != null || icon != null)) ...[
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.sp, color: const Color(0xFF6B7280)),
              SizedBox(width: 6.w),
            ],
            if (label != null)
              Text(
                label,
                style: GoogleFonts.arimo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
      ],
      TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        style: GoogleFonts.arimo(
          fontSize: 15.sp,
          color: const Color(0xFF1C1B1F),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.arimo(
            fontSize: 15.sp,
            color: const Color(0xFF9CA3AF),
          ),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    ],
  );
}
