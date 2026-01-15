import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProcedureScreen extends StatefulWidget {
  const EditProcedureScreen({super.key});

  @override
  State<EditProcedureScreen> createState() => _EditProcedureScreenState();
}

class _EditProcedureScreenState extends State<EditProcedureScreen> {
  // Controllers
  final TextEditingController _procedureNameController = TextEditingController(
    text: 'Total Knee Replacement',
  );
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(
    text: '2-3 hours',
  );
  final TextEditingController _leadSurgeonController = TextEditingController();
  final TextEditingController _teamMemberController = TextEditingController();
  final TextEditingController _operatingRoomController =
      TextEditingController();
  final TextEditingController _anesthesiaController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Team members list
  final List<String> _teamMembers = ['Dr. Mike Chen', 'Nurse Amy Park'];

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with gradient
            _buildHeader(),

            // Scrollable form content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),

                  // Procedure Information card
                  _buildProcedureInformationCard(),

                  SizedBox(height: 16.h),

                  // Personnel card
                  _buildPersonnelCard(),

                  SizedBox(height: 16.h),

                  // Location & Setup card
                  _buildLocationSetupCard(),

                  SizedBox(height: 16.h),

                  // Procedure Notes card
                  _buildProcedureNotesCard(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),

            // Bottom action buttons
            _buildBottomActions(),
          ],
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Edit Procedure',
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

  // Procedure Information card
  Widget _buildProcedureInformationCard() {
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
          // Section title
          Text(
            'Procedure Information',
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C1B1F),
            ),
          ),
          SizedBox(height: 16.h),
          // Procedure Name field
          Text(
            'Procedure Name',
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1C1B1F),
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _procedureNameController,
            style: GoogleFonts.arimo(
              fontSize: 15.sp,
              color: const Color(0xFF1C1B1F),
            ),
            decoration: InputDecoration(
              hintText: 'Total Knee Replacement',
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
          SizedBox(height: 16.h),
          // Date and Time fields
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16.sp,
                          color: const Color(0xFF6B7280),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Date',
                          style: GoogleFonts.arimo(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1C1B1F),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      style: GoogleFonts.arimo(
                        fontSize: 15.sp,
                        color: const Color(0xFF1C1B1F),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      onTap: () {
                        // TODO: Show date picker
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16.sp,
                          color: const Color(0xFF6B7280),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Time',
                          style: GoogleFonts.arimo(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1C1B1F),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: _timeController,
                      readOnly: true,
                      style: GoogleFonts.arimo(
                        fontSize: 15.sp,
                        color: const Color(0xFF1C1B1F),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      onTap: () {
                        // TODO: Show time picker
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Estimated Duration field
          Text(
            'Estimated Duration',
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1C1B1F),
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _durationController,
            style: GoogleFonts.arimo(
              fontSize: 15.sp,
              color: const Color(0xFF1C1B1F),
            ),
            decoration: InputDecoration(
              hintText: '2-3 hours',
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
      ),
    );
  }

  // Personnel card
  Widget _buildPersonnelCard() {
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
          // Section title
          Text(
            'Personnel',
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C1B1F),
            ),
          ),
          SizedBox(height: 16.h),
          // Lead Surgeon field
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 18.sp,
                color: const Color(0xFF6B7280),
              ),
              SizedBox(width: 6.w),
              Text(
                'Lead Surgeon',
                style: GoogleFonts.arimo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _leadSurgeonController,
            style: GoogleFonts.arimo(
              fontSize: 15.sp,
              color: const Color(0xFF1C1B1F),
            ),
            decoration: InputDecoration(
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
          SizedBox(height: 16.h),
          // Surgical Team section
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
          // Add team member field with button
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _teamMemberController,
                  style: GoogleFonts.arimo(
                    fontSize: 15.sp,
                    color: const Color(0xFF1C1B1F),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add team member',
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
              ),
              SizedBox(width: 8.w),
              // Add button
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
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.person_add,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Team members list
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
                      child: Icon(
                        Icons.delete_outline,
                        color: const Color(0xFFEF4444),
                        size: 20.sp,
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

  // Location & Setup card
  Widget _buildLocationSetupCard() {
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
          // Section title
          Text(
            'Location & Setup',
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C1B1F),
            ),
          ),
          SizedBox(height: 16.h),
          // Operating Room field
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18.sp,
                color: const Color(0xFF6B7280),
              ),
              SizedBox(width: 6.w),
              Text(
                'Operating Room',
                style: GoogleFonts.arimo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _operatingRoomController,
            style: GoogleFonts.arimo(
              fontSize: 15.sp,
              color: const Color(0xFF1C1B1F),
            ),
            decoration: InputDecoration(
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
          SizedBox(height: 16.h),
          // Anesthesia Type field
          Text(
            'Anesthesia Type',
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1C1B1F),
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _anesthesiaController,
            style: GoogleFonts.arimo(
              fontSize: 15.sp,
              color: const Color(0xFF1C1B1F),
            ),
            decoration: InputDecoration(
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
      ),
    );
  }

  // Procedure Notes card
  Widget _buildProcedureNotesCard() {
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
          // Section title with icon
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 20.sp,
                color: const Color(0xFF1C1B1F),
              ),
              SizedBox(width: 8.w),
              Text(
                'Procedure Notes',
                style: GoogleFonts.arimo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Notes text field
          TextField(
            controller: _notesController,
            maxLines: 5,
            style: GoogleFonts.arimo(
              fontSize: 15.sp,
              color: const Color(0xFF1C1B1F),
            ),
            decoration: InputDecoration(
              hintText: 'Add any special notes or requirements...',
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
          // Publish Button
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: Color(0xff9945FF),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(
                    'Save Changes',
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
