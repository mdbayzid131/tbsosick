import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import '../../../config/constants/image_paths.dart';
import 'edit_procedure.dart';
import 'controller/clender_controller.dart';

class ProcedureDetailsScreen extends StatefulWidget {
  final String id;
  const ProcedureDetailsScreen({super.key, required this.id});

  @override
  State<ProcedureDetailsScreen> createState() => _ProcedureDetailsScreenState();
}

class _ProcedureDetailsScreenState extends State<ProcedureDetailsScreen> {
  final CalendarController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getEventDetailById(id: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
        final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Obx(() {
        // Show loading indicator while data is being fetched
        if (_controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF9945FF)),
          );
        }

        // Show content when loading is complete
        return SafeArea(
          top: false,
          child: Stack(
            children: [

             SingleChildScrollView(
              child: Column(
                children: [
                  // Header section with gradient
                  _buildHeader(),
            
                  // Scrollable content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
            
                        // Duration and Location cards
                        Row(
                          children: [
                            Expanded(child: _buildDurationCard()),
                            SizedBox(width: 12.w),
                            Expanded(child: _buildLocationCard()),
                          ],
                        ),
            
                        SizedBox(height: 16.h),
            
                        // Primary Information card
                        _buildPrimaryInformationCard(),
            
                        SizedBox(height: 16.h),
            
                        // Surgical Team card
                        _buildSurgicalTeamCard(),
            
                        SizedBox(height: 16.h),
            
                        // Linked Preference Card
                        _buildLinkedPreferenceCard(),
            
                        SizedBox(height: 16.h),
            
                        // Procedure Notes card
                        _buildProcedureNotesCard(),
            
                        SizedBox(height: 16.h),
            
                        // Reminders card
                        _buildRemindersCard(),
            
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
            
                  // Bottom action buttons
                  _buildBottomActions(),
                ],
              ),
            ),
         
         Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: statusBarHeight, // status bar height + একটু extra
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF6C36B2)),
            ),
          ),
         ] ),
        );
      }),
    );
  }

  // Header with gradient background
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 50.h,
        bottom: 24.h,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF6C36B2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Event Details',
                style: GoogleFonts.arimo(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 36.w,
                  width: 36.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Procedure title and status
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Obx(() {
                        final e = _controller.eventDetails.value;
                        final t = e?.title ?? '';
                        return Text(
                          t,
                          style: GoogleFonts.arimo(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        );
                      }),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Upcoming',
                        style: GoogleFonts.arimo(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Date and time
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Obx(() {
                      final e = _controller.eventDetails.value;
                      String txt = '';
                      if (e != null) {
                        txt =
                            '${DateFormat('EEEE, MMMM d, y').format(e.date)} at ${e.time}';
                      }
                      return Text(
                        txt,
                        style: GoogleFonts.arimo(
                          fontSize: 14.sp,
                          color: Color(0xffE8DEF8),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Duration card
  Widget _buildDurationCard() {
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
              Icon(
                Icons.access_time_outlined,
                size: 18.sp,
                color: const Color(0xff79747E),
              ),
              SizedBox(width: 6.w),
              Text(
                'Duration',
                style: GoogleFonts.arimo(
                  fontSize: 13.sp,
                  color: const Color(0xff79747E),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Obx(() {
            final d = _controller.eventDetails.value;
            final t = d != null ? '${d.durationHours} hours' : '';
            return Text(
              t,
              style: GoogleFonts.arimo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1C1B1F),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Location card
  Widget _buildLocationCard() {
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
              Icon(
                Icons.location_on_outlined,
                size: 18.sp,
                color: const Color(0xff79747E),
              ),
              SizedBox(width: 6.w),
              Text(
                'Location',
                style: GoogleFonts.arimo(
                  fontSize: 13.sp,
                  color: const Color(0xff79747E),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Obx(() {
            final d = _controller.eventDetails.value;
            final t = d?.location ?? '';
            return Text(
              t,
              style: GoogleFonts.arimo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1C1B1F),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Primary Information card
  Widget _buildPrimaryInformationCard() {
    return Container(
      width: double.infinity,
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
          Text(
            'Primary Information',
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1C1B1F),
            ),
          ),
          SizedBox(height: 16.h),
          // Surgeon info
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xff7965AF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Surgeon',
                    style: GoogleFonts.arimo(
                      fontSize: 13.sp,
                      color: const Color(0xff79747E),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Obx(() {
                    final d = _controller.eventDetails.value;
                    final t = d?.personnel?.leadSurgeon ?? '';
                    return Text(
                      t,
                      style: GoogleFonts.arimo(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff1C1B1F),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Anesthesia info
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: const Color(0xffE8DEF8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: const Color(0xff6750A4),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anesthesia',
                    style: GoogleFonts.arimo(
                      fontSize: 13.sp,
                      color: const Color(0xff79747E),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'General',
                    style: GoogleFonts.arimo(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1C1B1F),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Surgical Team card
  Widget _buildSurgicalTeamCard() {
    return Container(
      width: double.infinity,
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
              Icon(
                Icons.people_outline,
                size: 20.sp,
                color: const Color(0xff1C1B1F),
              ),
              SizedBox(width: 8.w),
              Text(
                'Surgical Team (3)',
                style: GoogleFonts.arimo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1C1B1F),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Obx(() {
            final p = _controller.eventDetails.value?.personnel;
            final widgets = <Widget>[];
            if (p != null) {
              widgets.add(
                _buildTeamMember(
                  initials: _initials(p.leadSurgeon),
                  name: p.leadSurgeon,
                  role: 'Lead Surgeon',
                  isVerified: true,
                ),
              );
              for (final m in p.surgicalTeam) {
                widgets.add(SizedBox(height: 12.h));
                widgets.add(
                  _buildTeamMember(
                    initials: _initials(m),
                    name: m,
                    role: 'Team',
                    isVerified: false,
                  ),
                );
              }
            }
            return Column(children: widgets);
          }),
        ],
      ),
    );
  }

  // Team member item
  Widget _buildTeamMember({
    required String initials,
    required String name,
    required String role,
    required bool isVerified,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EFF4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Avatar with initials
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xffe1d2f6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.arimo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Name and role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.arimo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff1C1B1F),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  role,
                  style: GoogleFonts.arimo(
                    fontSize: 13.sp,
                    color: const Color(0xff79747E),
                  ),
                ),
              ],
            ),
          ),
          // Verified badge
          if (isVerified)
            SvgPicture.asset(
              ImagePaths.chosePlanIcon,
              width: 20.w,
              height: 20.w,
              colorFilter: ColorFilter.mode(
                const Color(0xFF4CAF50),
                BlendMode.srcIn,
              ),
            ),
        ],
      ),
    );
  }

  // Linked Preference Card
  Widget _buildLinkedPreferenceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xffEDE3FB),
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
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF6750A4),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Linked Preference Card',
                      style: GoogleFonts.arimo(
                        fontSize: 13.sp,
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _controller
                              .eventDetails
                              .value
                              ?.preferenceCard
                              ?.cardTitle ??
                          '',
                      style: GoogleFonts.arimo(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff1C1B1F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // View Card Details button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final d = _controller.eventDetails.value;
                final cardId = d!.preferenceCard?.id ?? '';
                Get.toNamed(
                  AppRoutes.CARD_DETAILS,
                  arguments: {'cardId': cardId},
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                elevation: 0,
              ),
              child: Text(
                'View Card Details',
                style: GoogleFonts.arimo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Procedure Notes card
  Widget _buildProcedureNotesCard() {
    return Container(
      width: double.infinity,
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
          Text(
            'Procedure Notes',
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1C1B1F),
            ),
          ),
          SizedBox(height: 8.h),
          Obx(() {
            final d = _controller.eventDetails.value;
            final t = d?.notes ?? '';
            return Text(
              t,
              style: GoogleFonts.arimo(
                fontSize: 14.sp,
                height: 1.5,
                color: const Color(0xFF6B7280),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Reminders card
  Widget _buildRemindersCard() {
    return Container(
      width: double.infinity,
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
              Icon(
                Icons.notifications_outlined,
                size: 20.sp,
                color: const Color(0xff6750A4),
              ),
              SizedBox(width: 8.w),
              Text(
                'Reminders',
                style: GoogleFonts.arimo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1C1B1F),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Reminder 1 - 1 hour before
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '1 hour before procedure',
                  style: GoogleFonts.arimo(
                    fontSize: 14.sp,
                    color: const Color(0xFF1C1B1F),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Reminder 2 - 24 hours before
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE8DEF8),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6750A4),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '24 hours before procedure',
                  style: GoogleFonts.arimo(
                    fontSize: 14.sp,
                    color: const Color(0xFF1C1B1F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom action buttons
  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Save Draft Button
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: Color(0xffF2F2F7),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Color(0xFF9945FF), width: 1.w),
                ),
                child: Center(
                  child: Text(
                    'Back',
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9945FF),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Publish Button
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                // Navigate to edit screen and wait for return
                await Get.to(() => EditProcedureScreen(id: widget.id));
                // Refresh event details after returning from edit
                await _controller.getEventDetailById(id: widget.id);
              },
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: Color(0xff9945FF),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(
                    'Edit Details',
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper
String _initials(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '';
  final parts = trimmed
      .split(RegExp(r'\\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  final take = parts.length >= 3 ? 3 : parts.length;
  final buf = StringBuffer();
  for (var i = 0; i < take; i++) {
    final s = parts[i];
    if (s.isNotEmpty) {
      buf.write(s[0].toUpperCase());
    }
  }
  return buf.toString();
}
