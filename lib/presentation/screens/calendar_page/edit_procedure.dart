import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tbsosick/config/constants/image_paths.dart';
import 'package:tbsosick/presentation/screens/calendar_page/controller/clender_controller.dart';
import 'package:tbsosick/data/models/create_event_request_model.dart';

class EditProcedureScreen extends StatefulWidget {
  const EditProcedureScreen({super.key, required this.id});
  final String id;

  @override
  State<EditProcedureScreen> createState() => _EditProcedureScreenState();
}

class _EditProcedureScreenState extends State<EditProcedureScreen> {
  final CalendarController calendarController = Get.find();
  late final TextEditingController _procedureNameController = TextEditingController(
    text: calendarController.eventDetails.value?.title ?? '',
  );

  late final TextEditingController _dateController = TextEditingController(
    text: calendarController.eventDetails.value?.date != null
        ? DateFormat('yyyy-MM-dd').format(calendarController.eventDetails.value!.date)
        : '',
  );
  late final TextEditingController _timeController = TextEditingController(
    text: calendarController.eventDetails.value?.time ?? '',
  );  
  late final TextEditingController _durationController = TextEditingController(
    text: calendarController.eventDetails.value?.durationHours.toString() ?? '1',
  );
  late final TextEditingController _leadSurgeonController = TextEditingController();
  late final TextEditingController _teamMemberController = TextEditingController();
  late final TextEditingController _operatingRoomController =
      TextEditingController();
  late final TextEditingController _anesthesiaController = TextEditingController();
  late final TextEditingController _notesController = TextEditingController();  

  List<String> _teamMembers = [];
  String _eventType = 'SURGERY';
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await calendarController.getEventDetailById(id: widget.id);
      final d = calendarController.eventDetails.value;
      if (d != null) {
        setState(() {
          _procedureNameController.text = d.title;
          _dateController.text = DateFormat('yyyy-MM-dd').format(d.date);
          _timeController.text = d.time;
          _durationController.text = d.durationHours.toString();
          _operatingRoomController.text = d.location;
          _notesController.text = d.notes ?? '';
          _leadSurgeonController.text = d.personnel?.leadSurgeon ?? '';
          _teamMembers = List<String>.from(d.personnel?.surgicalTeam ?? []);
          _eventType = d.eventType.toUpperCase();
        });
      }
    });
  }

  @override
  void dispose() {
    _procedureNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _durationController.dispose();
    _leadSurgeonController.dispose();
    _teamMemberController.dispose();
    _operatingRoomController.dispose();
    _anesthesiaController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: _buildHeader(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                _buildProcedureInformationCard(),
                SizedBox(height: 16.h),
                _buildPersonnelCard(),
                SizedBox(height: 16.h),
                _buildLocationSetupCard(),
                SizedBox(height: 16.h),
                _buildProcedureNotesCard(),
                SizedBox(height: 20.h),
                _buildBottomActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header
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
                              color: Color(0xFF6C36B2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Edit Event',
            style: GoogleFonts.arimo(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
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
    );
  }

  // Procedure Information Card
  Widget _buildProcedureInformationCard() {
    return _buildCard(
      title: 'Procedure Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Procedure Name',
            controller: _procedureNameController,
            hint: 'Total Knee Replacement',
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Date',
                  controller: _dateController,
                  icon: Icons.date_range_outlined,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF8B5CF6),
                              onPrimary: Colors.white,
                              onSurface: Color(0xFF1C1B1F),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(pickedDate);
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTextField(
                  label: 'Time',
                  controller: _timeController,
                  icon: Icons.access_time,
                  readOnly: true,
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF8B5CF6),
                              onPrimary: Colors.white,
                              onSurface: Color(0xFF1C1B1F),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null) {
                      final now = DateTime.now();
                      final dt = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      setState(() {
                        _timeController.text = DateFormat('HH:mm').format(dt);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Duration (hours)',
                  controller: _durationController,
                  hint: '2',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Type',
                      style: GoogleFonts.arimo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1C1B1F),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _eventType,
                          items: const [
                            DropdownMenuItem(value: 'SURGERY', child: Text('Surgery')),
                            DropdownMenuItem(value: 'MEETING', child: Text('Meeting')),
                            DropdownMenuItem(value: 'CONSULTATION', child: Text('Consultation')),
                            DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                          ],
                          onChanged: (v) {
                            setState(() {
                              _eventType = v ?? 'SURGERY';
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
        ],
      ),
    );
  }

  // Personnel Card
  Widget _buildPersonnelCard() {
    return _buildCard(
      title: 'Personnel',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Lead Surgeon',
            controller: _leadSurgeonController,
            icon: Icons.person_outline,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(
                Icons.people_outline,
                size: 18.sp,
                color: const Color(0xFF6B7280),
              ),
              SizedBox(width: 6.w),
              Text(
                'Surgical Team',
                style: GoogleFonts.arimo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _teamMemberController,
                  hint: 'Add team member',
                  showLabel: false,
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  if (_teamMemberController.text.isNotEmpty) {
                    setState(() {
                      _teamMembers.add(_teamMemberController.text);
                      _teamMemberController.clear();
                    });
                  }
                },
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
          ...(_teamMembers.map(
            (member) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      member,
                      style: GoogleFonts.arimo(
                        fontSize: 15.sp,
                        color: const Color(0xFF1C1B1F),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _teamMembers.remove(member);
                        });
                      },
                      child: SvgPicture.asset(
                        ImagePaths.deleteIcon,
                        height: 16.w,
                        width: 16.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  // Location & Setup Card
  Widget _buildLocationSetupCard() {
    return _buildCard(
      title: 'Location & Setup',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Operating Room',
            controller: _operatingRoomController,
            icon: Icons.location_on_outlined,
          ),
          SizedBox(height: 16.h),
          _buildTextField(
            label: 'Anesthesia Type',
            controller: _anesthesiaController,
          ),
        ],
      ),
    );
  }

  // Procedure Notes Card
  Widget _buildProcedureNotesCard() {
    return _buildCard(
      title: 'Procedure Notes',
      titleIcon: Icons.description_outlined,
      child: _buildTextField(
        controller: _notesController,
        hint: 'Add any special notes or requirements...',
        maxLines: 5,
        showLabel: false,
      ),
    );
  }

  // Bottom Actions
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
          Expanded(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F7),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFF9945FF),
                    width: 1.w,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
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
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final title = _procedureNameController.text.trim();
                final date = _dateController.text.trim();
                final time = _timeController.text.trim();
                final loc = _operatingRoomController.text.trim();
                final dur = int.tryParse(_durationController.text.trim()) ?? 1;
                final notes = _notesController.text.trim();
                setState(() {
                  _submitting = true;
                });
                final personnel = PersonnelRequestModel(
                  leadSurgeon: _leadSurgeonController.text.trim(),
                  surgicalTeam: List<String>.from(_teamMembers),
                );
                await calendarController.updateEvent(
                  id: widget.id,
                  title: title,
                  date: date,
                  time: time,
                  durationHours: dur,
                  eventType: _eventType,
                  location: loc,
                  notes: notes,
                  personnel: personnel,
                );
                setState(() {
                  _submitting = false;
                });
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: const Color(0xff9945FF),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(
                    _submitting ? 'Saving...' : 'Save Changes',
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

  // Reusable Card Widget
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
}
