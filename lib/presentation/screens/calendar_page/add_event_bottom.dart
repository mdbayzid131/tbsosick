import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

import '../../../config/constants/image_paths.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_time_picker.dart';
import 'controller/clender_controller.dart';
import 'package:tbsosick/data/models/create_event_request_model.dart';

void showAddEventBottomSheet(
  BuildContext context, {
  DateTime? initialDate,
  VoidCallback? onEventCreated,
}) {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final notesController = TextEditingController();
  final locationController = TextEditingController();
  final durationController = TextEditingController(text: '1');
  final linkPreferenceCardIdController = TextEditingController();

  final leadSurgeonController = TextEditingController();
  final teamMemberController = TextEditingController();

  List<String> teamMembers = [];
  String eventType = 'SURGERY';
  bool submitting = false;
  final CalendarController controller = Get.find<CalendarController>();

  if (initialDate != null) {
    dateController.text = DateFormat('yyyy-MM-dd').format(initialDate);
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20.r,
                    offset: Offset(0, -5.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.addEvent,
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
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: titleController,
                              label: l10n.eventTitleLabel,
                              hintText: l10n.enterEventTitle,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? l10n.titleRequired
                                  : null,
                            ),

                            SizedBox(height: 12.h),

                            CustomDatePickerField(
                              controller: dateController,
                              label: '${l10n.date} *',
                              hintText: l10n.selectDate,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? l10n.dateRequired
                                  : null,
                            ),

                            SizedBox(height: 12.h),

                            CustomTimePickerField(
                              controller: timeController,
                              label: '${l10n.time} *',
                              hintText: l10n.selectTime,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? l10n.timeRequired
                                  : null,
                            ),

                            SizedBox(height: 12.h),
                            CustomTextField(
                              controller: locationController,
                              label: l10n.locationRequired,
                              hintText: l10n.enterLocationHint,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? l10n.locationRequired
                                  : null,
                            ),
                            SizedBox(height: 12.h),
                            CustomTextField(
                              controller: linkPreferenceCardIdController,
                              label: l10n.linkedPreferenceCard,
                              hintText: l10n.linkPreferenceCardOptional,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return null;
                                if (v.trim().length != 24) {
                                  return l10n.prefCardIdLengthError;
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: durationController,
                                    label: '${l10n.durationHours} *',
                                    hintText: 'e.g., 2',
                                    keyboardType: TextInputType.number,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return l10n.durationRequired;
                                      }
                                      final d = int.tryParse(v.trim());
                                      if (d == null || d <= 0) {
                                        return l10n.enterValidPositiveNumber;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.eventTypeLabel,
                                        style: GoogleFonts.arimo(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff333333),
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF2F2F7),
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: eventType,
                                            items: [
                                              DropdownMenuItem(
                                                value: 'SURGERY',
                                                child: Text(
                                                  l10n.surgery,
                                                  style: GoogleFonts.arimo(
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff8E8E93),
                                                  ),
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: 'MEETING',
                                                child: Text(
                                                  l10n.meeting,
                                                  style: GoogleFonts.arimo(
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff8E8E93),
                                                  ),
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: 'CONSULTATION',
                                                child: Text(
                                                  l10n.consultation,
                                                  style: GoogleFonts.arimo(
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff8E8E93),
                                                  ),
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: 'OTHER',
                                                child: Text(
                                                  l10n.other,
                                                  style: GoogleFonts.arimo(
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff8E8E93),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            onChanged: (val) {
                                              setState(() {
                                                eventType = val ?? 'SURGERY';
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16.h),

                            /// PERSONNEL CARD
                            _buildPersonnelCard(
                              l10n: l10n,
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
                              label: l10n.notes,
                              hintText: l10n.addNotesHint,
                              maxLines: 4,
                            ),

                            SizedBox(height: 24.h),

                            CustomElevatedButton(
                              label: submitting
                                  ? l10n.creating
                                  : l10n.createEvent,
                              onPressed: submitting
                                  ? null
                                  : () async {
                                      if (!(formKey.currentState?.validate() ??
                                          false)) {
                                        return;
                                      }
                                      final title = titleController.text.trim();
                                      final date = dateController.text.trim();
                                      final time = timeController.text.trim();
                                      final loc = locationController.text
                                          .trim();
                                      final notes = notesController.text.trim();
                                      final dur =
                                          int.tryParse(
                                            durationController.text.trim(),
                                          ) ??
                                          1;

                                      setState(() {
                                        submitting = true;
                                      });

                                      final personnel = PersonnelRequestModel(
                                        leadSurgeon: leadSurgeonController.text
                                            .trim(),
                                        surgicalTeamMembers: List<String>.from(
                                          teamMembers,
                                        ),
                                      );

                                      await controller.postEvent(
                                        title: title,
                                        date: date,
                                        time: time,
                                        durationInHours: dur,
                                        eventType: eventType,
                                        location: loc,
                                        preferenceCard:
                                            linkPreferenceCardIdController.text
                                                .trim(),
                                        keyNotes: notes,
                                        personnel: personnel,
                                      );

                                      setState(() {
                                        submitting = false;
                                      });

                                      // Trigger the refresh indicator animation
                                      onEventCreated?.call();

                                      // Close the bottom sheet after a brief delay to allow UI to update
                                      await Future.delayed(
                                        const Duration(milliseconds: 300),
                                      );
                                      Get.back();
                                    },
                            ),

                            SizedBox(height: 30.h),
                          ],
                        ),
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
  required AppLocalizations l10n,
  required TextEditingController leadSurgeonController,
  required TextEditingController teamMemberController,
  required List<String> teamMembers,
  required VoidCallback onAdd,
  required Function(String) onRemove,
}) {
  return _buildCard(
    title: l10n.personnel,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: l10n.leadSurgeon,
          controller: leadSurgeonController,
          icon: Icons.person_outline,
          validator: (value) =>
              value?.isEmpty ?? true ? l10n.pleaseEnterLeadSurgeon : null,
        ),

        SizedBox(height: 16.h),

        Text(
          l10n.surgicalTeam,
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
                hint: l10n.addTeamMember,
                showLabel: false,
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9945FF), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9945FF).withValues(alpha: 0.3),
                      blurRadius: 8.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 28.sp,
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
  String? Function(String?)? validator,
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
      TextFormField(
        controller: controller,
        validator: validator,
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
          fillColor: const Color(0xFFF3F4F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(color: Color(0xFF9945FF), width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          prefixIcon: icon != null
              ? Icon(icon, color: const Color(0xFF9945FF), size: 20.sp)
              : null,
        ),
      ),
    ],
  );
}
