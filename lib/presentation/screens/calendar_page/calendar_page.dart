import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_event_bottom.dart';
import 'event_details_bottom.dart';
import 'procedure_details.dart';
import 'controller/clender_controller.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Calendar controller
  DateTime _focusedDay = DateTime(2026, 1, 12);
  DateTime? _selectedDay = DateTime(2026, 1, 12);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final CalendarController _controller = Get.put(CalendarController());

  @override
  void initState() {
    super.initState();
    _controller.getEvents();
  }
final CalendarController calenderController = Get.find<CalendarController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: RefreshIndicator(
        color: const Color(0xFF9945FF),
        onRefresh: _controller.refreshEvents,
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                Obx(() => _controller.isLoading.value
                    ? const LinearProgressIndicator(
                        color: Color(0xFF9945FF),
                        minHeight: 2,
                      )
                    : const SizedBox.shrink()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      _buildCalendar(),
                      SizedBox(height: 20.h),
                      _buildNoEventsCard(),
                      SizedBox(height: 20.h),
                      _buildUpcomingEventsSection(),
                      SizedBox(height: 20.h),
                      _buildEventTypesLegend(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
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
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF9945FF), Color(0xFF271E3E)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Text(
        'Calendar',
        style: GoogleFonts.arimo(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // Calendar widget
  Widget _buildCalendar() {
    return Container(
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
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        // Calendar styling
        calendarStyle: CalendarStyle(
          // Today's date styling
          todayDecoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          // Selected date styling
          selectedDecoration: const BoxDecoration(
            color: Color(0xFF9945FF),
            shape: BoxShape.circle,
          ),
          // Default text style
          defaultTextStyle: GoogleFonts.arimo(
            fontSize: 14.sp,
            color: const Color(0xFF1C1B1F),
          ),
          // Weekend text style
          weekendTextStyle: GoogleFonts.arimo(
            fontSize: 14.sp,
            color: const Color(0xFF1C1B1F),
          ),
          // Selected text style
          selectedTextStyle: GoogleFonts.arimo(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          // Today text style
          todayTextStyle: GoogleFonts.arimo(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8B5CF6),
          ),
        ),
        // Header styling
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.arimo(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000000),
          ),
          leftChevronIcon: Container(
            width: 40.w,
            height: 40.h,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F2F7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_left,
              color: const Color(0xFF1C1B1F),
              size: 24.sp,
            ),
          ),
          rightChevronIcon: Container(
            width: 40.w,
            height: 40.h,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F2F7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_right,
              color: const Color(0xFF1C1B1F),
              size: 24.sp,
            ),
          ),
        ),
        // Days of week styling,
      ),
    );
  }

  // No events scheduled card
  Widget _buildNoEventsCard() {
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
        children: [
          // Calendar icon with date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, MMMM d').format(_selectedDay ?? _focusedDay),
                style: GoogleFonts.arimo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
              Container(
                width: 40.w,
                height: 40.h,
                decoration: const BoxDecoration(
                  color: Color(0xFF9945FF),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    final dateToUse = _selectedDay ?? _focusedDay;
                    showAddEventBottomSheet(context, initialDate: dateToUse);
                  },
                  child: Icon(Icons.add, color: Colors.white, size: 24.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('MMM').format(_selectedDay ?? _focusedDay).toUpperCase(),
                  style: GoogleFonts.arimo(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff79747E),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  DateFormat('d').format(_selectedDay ?? _focusedDay),
                  style: GoogleFonts.arimo(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1C1B1F),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // No events text
          Text(
            'No events scheduled',
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          SizedBox(height: 8.h),
          // Add Event button
          TextButton(
            onPressed: () {
              // TODO: Add event functionality
              showAddEventBottomSheet(context);
            },
            child: Text(
              'Add Event',
              style: GoogleFonts.arimo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9945FF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Upcoming Events section
  Widget _buildUpcomingEventsSection() {
    return Obx(() {
      final items = _controller.events;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Events',
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1C1B1F),
            ),
          ),
          SizedBox(height: 12.h),
          ...List.generate(items.length, (index) {
            final e = items[index];
            final color = _eventTypeColor(e.eventType);
            final timeText =
                '${e.time} - ${e.durationHours} ${e.durationHours == 1 ? 'hour' : 'hours'}';
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildEventCard(
                id: e.id,
                title: e.title,
                type: e.eventType,
                typeColor: color,
                time: timeText,
                location: e.location,
                patient: null,
              ),
            );
          }),
        ],
      );
    });
  }

  // Individual event card
  Widget _buildEventCard({
    required String title,
    required String id,
    required String type,
    required Color typeColor,
    required String time,
    required String location,
    String? patient,
  }) {
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
          // Title
          Text(
            title,
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1C1B1F),
            ),
          ),
          SizedBox(height: 8.h),
          // Event type tag
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: typeColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              type,
              style: GoogleFonts.arimo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Time
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16.sp,
                color: const Color(0xff79747E),
              ),
              SizedBox(width: 6.w),
              Text(
                time,
                style: GoogleFonts.arimo(
                  fontSize: 13.sp,
                  color: const Color(0xff79747E),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          // Location
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16.sp,
                color: const Color(0xff79747E),
              ),
              SizedBox(width: 6.w),
              Text(
                location,
                style: GoogleFonts.arimo(
                  fontSize: 13.sp,
                  color: const Color(0xff79747E),
                ),
              ),
            ],
          ),
          // Patient info (if available)
          if (patient != null) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16.sp,
                  color: const Color(0xff79747E),
                ),
                SizedBox(width: 6.w),
                Text(
                  patient,
                  style: GoogleFonts.arimo(
                    fontSize: 13.sp,
                    color: const Color(0xff79747E),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 16.h),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: View details functionality
       
                            showEventDetailsBottomSheet( context: context, id: id);
                          calenderController.getEventDetailById(id:id);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF9945FF),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'View Details',
                    style: GoogleFonts.arimo(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9945FF),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: View card functionality
                    Get.to( ProcedureDetailsScreen(id: id,));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9945FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    elevation: 0,
                  ),
                  child: Text(
                    'View Card',
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
        ],
      ),
    );
  }

  // Event Types legend
  Widget _buildEventTypesLegend() {
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
          Text(
            'Event Types',
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C1B1F),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildEventTypeLegendItem('Surgery', const Color(0xFF9945FF)),
              SizedBox(width: 16.w),
              _buildEventTypeLegendItem('Meeting', const Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  // Event type legend item
  Widget _buildEventTypeLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: GoogleFonts.arimo(
            fontSize: 14.sp,
            color: const Color(0xff79747E),
          ),
        ),
      ],
    );
  }

  Color _eventTypeColor(String type) {
    final t = type.toLowerCase();
    if (t.contains('surgery')) return const Color(0xFF9945FF);
    if (t.contains('meeting')) return const Color(0xFFF59E0B);
    return const Color(0xFF6B7280);
  }
}
