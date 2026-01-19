import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/screens/home/Preference%20card/sutures_container.dart';
import 'package:tbsosick/presentation/widgets/CustomContainer.dart';
import 'medical_supplies_container.dart';

class NewPreferenceCard extends StatefulWidget {
  const NewPreferenceCard({super.key});

  @override
  State<NewPreferenceCard> createState() => _NewPreferenceCardState();
}

class _NewPreferenceCardState extends State<NewPreferenceCard> {
  // Text controller for key notes
  final TextEditingController _keyNotesController = TextEditingController();

  @override
  void dispose() {
    _keyNotesController.dispose();
    super.dispose();
  }

  // Handle image picker
  void _pickImages() {
    // TODO: Implement image picker functionality
    print('Pick images from library or camera');
  }

  // Handle save draft
  void _saveDraft() {
    // TODO: Implement save draft functionality
    Get.back();
    print('Save draft');
  }

  // Handle publish
  void _publish() {
    Get.back();
    // TODO: Implement publish functionality
    print('Publish');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F7),
      appBar: AppBar(
        leadingWidth: 100.w,
        leading: Center(
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.arimo(
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff9945FF),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'New Preference Card',
          style: GoogleFonts.arimo(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xffffffff),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Publish',
              style: GoogleFonts.arimo(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xff9945FF),
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),

                // Surgeon Profile Section
                CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SURGEON PROFILE',
                        style: GoogleFonts.arimo(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff8E8E93),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30.w,
                            backgroundColor: Color(0xffF2F2F7),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.grey,
                              size: 30.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Photo',
                                style: GoogleFonts.arimo(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff000000),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'Upload from library or camera',
                                style: GoogleFonts.arimo(
                                  fontSize: 13.sp,
                                  color: Color(0xff8E8E93),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.add_circle_outlined,
                            size: 30.sp,
                            color: Color(0xff14F195),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                CustomContainer(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Card Title',
                          style: GoogleFonts.arimo(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff8E8E93),
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          labelStyle: GoogleFonts.arimo(
                            fontSize: 16.sp,
                            color: const Color(0xff9E9E9E),
                          ),
                          hintText: 'Surgeon Name — Procedure Name',
                          hintStyle: GoogleFonts.arimo(
                            fontSize: 18.sp,
                            color: const Color(0xffC6C6C8),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Surgeon Details Section
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the container
                    borderRadius: BorderRadius.circular(
                      20.r,
                    ),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1.w,
                    ),
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'SURGEON DETAILS',
                            style: GoogleFonts.arimo(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff8E8E93),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Divider(height: 1.5.h, color: Color(0xffEEEEEF)),

                      SizedBox(height: 10.h),

                      // Full Name TextFormField
                      _buildTextField('Full Name', 'Enter full name'),
                      SizedBox(height: 10.h),
                      Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                      SizedBox(height: 10.h),

                      // Hand Preference TextFormField
                      _buildTextField(
                        'Hand Preference (Surgeon)',
                        'Enter hand preference',
                      ),
                      SizedBox(height: 10.h),
                      Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                      SizedBox(height: 10.h),

                      // Specialty TextFormField
                      _buildTextField('Specialty', 'e.g., Orthopedic Surgery'),
                      SizedBox(height: 10.h),
                      Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                      SizedBox(height: 10.h),

                      // Contact Number TextFormField
                      _buildTextField('Contact Number', '(555) 123-4567'),
                      SizedBox(height: 10.h),
                      Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                      SizedBox(height: 10.h),

                      // Music Preferences TextFormField
                      _buildTextField(
                        'Music Preferences',
                        'Preferred music or silence',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                CustomContainer(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Medication',
                          style: GoogleFonts.arimo(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff000000),
                            height: 1.5.h,
                          ),
                        ),
                      ),
                      TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          labelStyle: GoogleFonts.arimo(
                            fontSize: 14.sp,
                            color: const Color(0xff9E9E9E),
                          ),
                          hintText: 'List all required medications...',
                          hintStyle: GoogleFonts.arimo(
                            fontSize: 17.sp,
                            color: const Color(0xffC6C6C8),
                            height: 1.5.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: false,
                          fillColor: const Color(0xffF2F2F7),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                MedicalSuppliesScreen(),

                SizedBox(height: 20.h),
                SuturesContainer(),
                SizedBox(height: 20.h),
                CustomContainer(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Instruments',
                          style: GoogleFonts.arimo(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff000000),
                            height: 1.5.h,
                          ),
                        ),
                      ),
                      TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          labelStyle: GoogleFonts.arimo(
                            fontSize: 14.sp,
                            color: const Color(0xff9E9E9E),
                          ),
                          hintText: 'List all required instruments...',
                          hintStyle: GoogleFonts.arimo(
                            fontSize: 17.sp,
                            color: const Color(0xffC6C6C8),
                            height: 1.5.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: false,
                          fillColor: const Color(0xffF2F2F7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                CustomContainer(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Positioning Equipment / Placement',
                          style: GoogleFonts.arimo(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff000000),
                            height: 1.5.h,
                          ),
                        ),
                      ),
                      TextFormField(
                        maxLines: 2,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          labelStyle: GoogleFonts.arimo(
                            fontSize: 14.sp,
                            color: const Color(0xff9E9E9E),
                          ),
                          hintText: 'e.g., Leg holders, arm boards',
                          hintStyle: GoogleFonts.arimo(
                            fontSize: 17.sp,
                            color: const Color(0xffC6C6C8),
                            height: 1.5.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: false,
                          fillColor: const Color(0xffF2F2F7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                CustomContainer(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Positioning / Prepping',
                          style: GoogleFonts.arimo(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff000000),
                            height: 1.5.h,
                          ),
                        ),
                      ),
                      TextFormField(
                        maxLines: 2,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          labelStyle: GoogleFonts.arimo(
                            fontSize: 14.sp,
                            color: const Color(0xff9E9E9E),
                          ),
                          hintText: 'Patient positioning',
                          hintStyle: GoogleFonts.arimo(
                            fontSize: 17.sp,
                            color: const Color(0xffC6C6C8),
                            height: 1.5.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: false,
                          fillColor: const Color(0xffF2F2F7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                CustomContainer(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Operative Workflow',
                          style: GoogleFonts.arimo(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff000000),
                            height: 1.5.h,
                          ),
                        ),
                      ),
                      TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          labelStyle: GoogleFonts.arimo(
                            fontSize: 14.sp,
                            color: const Color(0xff9E9E9E),
                          ),
                          hintText: 'Steps of the Case',
                          hintStyle: GoogleFonts.arimo(
                            fontSize: 17.sp,
                            color: const Color(0xffC6C6C8),
                            height: 1.5.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: false,
                          fillColor: const Color(0xffF2F2F7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Cancel and Publish buttons

                // Key Notes Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(13.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFF3CD),
                        const Color(0xFFFFE69C),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border.all(
                      color: const Color(0xFFFFE082),
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Key Notes Header
                      Text(
                        '⚠️ Key Notes',
                        style: GoogleFonts.arimo(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Text Field
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffFFF5D5),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Center(
                          child: TextField(
                            controller: _keyNotesController,
                            maxLines: 3,
                            style: GoogleFonts.arimo(
                              fontSize: 14.sp,
                              color: const Color(0xFF9CA3AF),
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                              ),
                              border: InputBorder.none,
                              hintText:
                                  'Critical reminders and important notes...',
                              hintStyle: GoogleFonts.arimo(
                                fontSize: 14.sp,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Photo Library Section
                CustomContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo Library Header
                      Text(
                        'Photo library',
                        style: GoogleFonts.arimo(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Add Photo Container
                      GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 50.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F7),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image Icon
                              Icon(
                                Icons.image_outlined,
                                size: 48.sp,
                                color: const Color(0xFFBDBDBD),
                              ),
                              SizedBox(height: 16.h),
                              // Add multiple picture text
                              Text(
                                'Add multiple picture',
                                style: GoogleFonts.arimo(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF9945FF),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              // From library or camera text
                              Text(
                                'From library or camera',
                                style: GoogleFonts.arimo(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF8E8E93),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Action Buttons
              ],
            ),
          ),
          SizedBox(height: 20.h),

          SafeArea(
            top: false,
            child: Container(
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
                      onTap: _saveDraft,
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Color(0xffF2F2F7),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Center(
                          child: Text(
                            'Save Draft',
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
                      onTap: _publish,
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Color(0xff9945FF),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save_outlined,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Publish',
                              style: GoogleFonts.arimo(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create text fields
  Widget _buildTextField(String label, String hint) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: GoogleFonts.arimo(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff8E8E93),
              ),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              labelStyle: GoogleFonts.arimo(
                fontSize: 14.sp,
                color: const Color(0xff9E9E9E),
              ),
              hintText: hint,
              hintStyle: GoogleFonts.arimo(
                fontSize: 17.sp,
                color: const Color(0xffC6C6C8),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              filled: false,
              fillColor: const Color(0xffF2F2F7),
            ),
          ),
        ],
      ),
    );
  }
}
