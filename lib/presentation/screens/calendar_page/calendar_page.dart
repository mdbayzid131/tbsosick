import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

import 'add_event_bottom.dart';
import 'event_details_bottom.dart';
import 'procedure_details.dart';
import 'edit_procedure.dart';
import 'controller/clender_controller.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final CalendarController _controller = Get.put(CalendarController());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _fetchHighlightsForMonth(_focusedDay);
    _fetchEventsForDate(_selectedDay ?? _focusedDay);
  }

  void _fetchHighlightsForMonth(DateTime focusedDay) {
    final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
    final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 0);
    _controller.getCalendarHighlights(
      from: DateFormat('yyyy-MM-dd').format(firstDay),
      to: DateFormat('yyyy-MM-dd').format(lastDay),
    );
  }

  void _fetchEventsForDate(DateTime date) {
    _controller.getEvents(date: DateFormat('yyyy-MM-dd').format(date));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF271E3E),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: const Color(0xFF9945FF),
          onRefresh: () async =>
              await Future.delayed(const Duration(seconds: 1)),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              const SliverToBoxAdapter(child: SizedBox.shrink()),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 20.h),
                    _buildCalendar(),
                    SizedBox(height: 20.h),
                    _buildNoEventsCard(),
                    SizedBox(height: 20.h),
                    _buildUpcomingEventsSection(),
                    SizedBox(height: 20.h),
                    _buildEventTypesLegend(),
                    SizedBox(height: 30.h),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 60.h,
      collapsedHeight: 60.h,
      toolbarHeight: 60.h,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF6C36B2),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsetsDirectional.only(start: 20.w, bottom: 16.h),
        title: Text(
          AppLocalizations.of(context)!.calendar,
          style: GoogleFonts.arimo(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            color: Color(0xFF6C36B2),
          ),
        ),
        collapseMode: CollapseMode.pin,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(16.w),
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
      child: child,
    );
  }

  // Calendar widget
  Widget _buildCalendar() {
    return _buildCard(
      padding: EdgeInsets.zero,
      child: Obx(() {
        // Explicitly access the observable map to register the dependency for GetX
        final _ = _controller.calendarHighlights.length;

        return TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _fetchEventsForDate(selectedDay);
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
            _fetchHighlightsForMonth(focusedDay);
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final dateStr = DateFormat('yyyy-MM-dd').format(day);
              if (_controller.calendarHighlights.containsKey(dateStr)) {
                final count = _controller.calendarHighlights[dateStr]!;
                // Intensity based on count
                double opacity = 0.2 + (count * 0.2);
                if (opacity > 1.0) opacity = 1.0;

                return Container(
                  margin: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(opacity),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: GoogleFonts.arimo(
                      fontSize: 14.sp,
                      color: const Color(0xFF1C1B1F),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: Color(0xFF9945FF),
              shape: BoxShape.circle,
            ),
            defaultTextStyle: GoogleFonts.arimo(
              fontSize: 14.sp,
              color: const Color(0xFF1C1B1F),
            ),
            weekendTextStyle: GoogleFonts.arimo(
              fontSize: 14.sp,
              color: const Color(0xFF1C1B1F),
            ),
            selectedTextStyle: GoogleFonts.arimo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            todayTextStyle: GoogleFonts.arimo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8B5CF6),
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: GoogleFonts.arimo(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF000000),
            ),
            leftChevronIcon: _buildChevron(Icons.chevron_left),
            rightChevronIcon: _buildChevron(Icons.chevron_right),
          ),
        );
      }),
    );
  }

  Widget _buildChevron(IconData icon) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F7),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color(0xFF1C1B1F), size: 24.sp),
    );
  }

  // No events scheduled card
  Widget _buildNoEventsCard() {
    final dateToUse = _selectedDay ?? _focusedDay;
    return _buildCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, MMMM d').format(dateToUse),
                style: GoogleFonts.arimo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
              _buildAddButton(dateToUse),
            ],
          ),
          SizedBox(height: 16.h),
          _buildDateIndicator(dateToUse),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () => _openAddEvent(dateToUse),
            child: Text(
              AppLocalizations.of(context)!.addEvent,
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

  Widget _buildAddButton(DateTime date) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: const BoxDecoration(
        color: Color(0xFF9945FF),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: () => _openAddEvent(date),
        child: Icon(Icons.add, color: Colors.white, size: 24.sp),
      ),
    );
  }

  Widget _buildDateIndicator(DateTime date) {
    return Container(
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
            DateFormat('MMM').format(date).toUpperCase(),
            style: GoogleFonts.arimo(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff79747E),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            DateFormat('d').format(date),
            style: GoogleFonts.arimo(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1C1B1F),
            ),
          ),
        ],
      ),
    );
  }

  void _openAddEvent(DateTime? date) {
    showAddEventBottomSheet(
      context,
      initialDate: date,
      onEventCreated: () => _refreshIndicatorKey.currentState?.show(),
    );
  }

  // Upcoming Events section
  Widget _buildUpcomingEventsSection() {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: Color(0xFF9945FF)),
          ),
        );
      }

      if (_controller.events.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.upcomingEvents,
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1C1B1F),
            ),
          ),
          SizedBox(height: 12.h),
          ..._controller.events.map(
            (event) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildEventCard(
                id: event.id,
                title: event.title,
                type: event.eventType,
                typeColor: event.eventType == 'SURGERY'
                    ? const Color(0xFF9945FF)
                    : const Color(0xFFF59E0B),
                time: event.time,
                location: event.location,
                patient: event.notes,
              ),
            ),
          ),
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
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.arimo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 24.sp,
                width: 24.sp,
                child: PopupMenuButton<String>(
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.to(() => EditProcedureScreen(id: id));
                    } else if (value == 'delete') {
                      _showDeleteDialog(context, id);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 20.sp,
                            color: const Color(0xFF1C1B1F),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            AppLocalizations.of(context)!.edit,
                            style: GoogleFonts.arimo(
                              fontSize: 14.sp,
                              color: const Color(0xFF1C1B1F),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 20.sp,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            AppLocalizations.of(context)!.delete,
                            style: GoogleFonts.arimo(
                              fontSize: 14.sp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert_rounded,
                    size: 20.sp,
                    color: const Color(0xff79747E),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(children: [_buildTypeChip(type, typeColor)]),
          SizedBox(height: 12.h),
          _buildIconInfo(Icons.access_time, time),
          SizedBox(height: 6.h),
          _buildIconInfo(Icons.location_on_outlined, location),
          if (patient != null) ...[
            SizedBox(height: 6.h),
            _buildIconInfo(Icons.person_outline, patient),
          ],
          SizedBox(height: 16.h),
          _buildEventActions(id),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String type, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
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
    );
  }

  Widget _buildIconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: const Color(0xff79747E)),
        SizedBox(width: 6.w),
        Text(
          text,
          style: GoogleFonts.arimo(
            fontSize: 13.sp,
            color: const Color(0xff79747E),
          ),
        ),
      ],
    );
  }

  Widget _buildEventActions(String id) {
    return Row(
      children: [
        // Expanded(
        //   child: OutlinedButton(
        //     onPressed: () => showEventDetailsBottomSheet(context: context, id: id),
        //     style: OutlinedButton.styleFrom(
        //       side: const BorderSide(color: Color(0xFF9945FF), width: 1.5),
        //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        //       padding: EdgeInsets.symmetric(vertical: 10.h),
        //     ),
        //     child: Text(
        //       AppLocalizations.of(context)!.viewDetails,
        //       style: GoogleFonts.arimo(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color(0xFF9945FF)),
        //     ),
        //   ),
        // ),
        // SizedBox(width: 8.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Get.to(ProcedureDetailsScreen(id: id)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9945FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              elevation: 0,
            ),
            child: Text(
              AppLocalizations.of(context)!.viewDetails,
              style: GoogleFonts.arimo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Event Types legend
  Widget _buildEventTypesLegend() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.eventTypes,
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C1B1F),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildEventTypeLegendItem(
                AppLocalizations.of(context)!.surgery,
                const Color(0xFF9945FF),
              ),
              SizedBox(width: 16.w),
              _buildEventTypeLegendItem(
                AppLocalizations.of(context)!.meeting,
                const Color(0xFFF59E0B),
              ),
            ],
          ),
        ],
      ),
    );
  }

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

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        // title: Text(AppLocalizations.of(context)!.deleteEvent),
        // content: Text(AppLocalizations.of(context)!.deleteEventConfirmation),
        title: Text(
          "Delete Event",
          style: GoogleFonts.arimo(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1C1B1F),
          ),
        ),
        content: Text(
          "Are you sure you want to delete this event?",
          style: GoogleFonts.arimo(
            fontSize: 14.sp,
            color: const Color(0xff79747E),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              _controller.deleteEvent(id, context);
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
