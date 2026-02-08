import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/controllers/homepgeController.dart';
import 'package:tbsosick/presentation/controllers/post_any__card_controller.dart';
import 'package:tbsosick/presentation/screens/home/Preference%20card/sutures_container.dart';
import 'package:tbsosick/presentation/widgets/CustomContainer.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';
import 'medical_supplies_container.dart';

class NewPreferenceCard extends StatefulWidget {
  final bool isPrivate;
  const NewPreferenceCard({super.key, required this.isPrivate});

  @override
  State<NewPreferenceCard> createState() => _NewPreferenceCardState();
}

class _NewPreferenceCardState extends State<NewPreferenceCard> {
  // Text controller for key notes

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clear controllers when leaving the page
    postAnyCardController.clearAllControllers();
    super.dispose();
  }

  HomePageController homePageController = Get.find();
  PostAnyCardController postAnyCardController = Get.find();

  @override
  void initState() {
    super.initState();
    homePageController.getSupplies();
    homePageController.getSutures();
  }

  // Handle publish
  void _publish() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    postAnyCardController.submitPreferenceCard(widget.isPrivate);
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
          widget.isPrivate ? 'New Private Card' : 'New Preference Card',
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
              widget.isPrivate ? 'Save' : 'Publish',
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
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // Surgeon Profile Section
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
                          controller: postAnyCardController.cardTitleController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Card Title is required'
                              : null,
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
                      borderRadius: BorderRadius.circular(20.r),
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
                        _buildTextField(
                          label: 'Full Name',
                          hint: 'Enter full name',
                          controller: postAnyCardController.fullNameController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Full Name is required'
                              : null,
                        ),
                        SizedBox(height: 10.h),
                        Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                        SizedBox(height: 10.h),

                        // Hand Preference TextFormField
                        _buildTextField(
                          label: 'Hand Preference (Surgeon)',
                          hint: 'Enter hand preference',
                          controller:
                              postAnyCardController.handpreferenceController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Hand Preference is required'
                              : null,
                        ),
                        SizedBox(height: 10.h),
                        Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                        SizedBox(height: 10.h),

                        // Specialty TextFormField
                        _buildTextField(
                          label: 'Specialty',
                          hint: 'e.g., Orthopedic Surgery',
                          controller:
                              postAnyCardController.specialitiesController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Specialty is required'
                              : null,
                        ),
                        SizedBox(height: 10.h),
                        Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                        SizedBox(height: 10.h),

                        // Contact Number TextFormField
                        _buildTextField(
                          label: 'Contact Number',
                          hint: '(555) 123-4567',
                          controller: postAnyCardController.contactController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Contact Number is required'
                              : null,
                        ),
                        SizedBox(height: 10.h),
                        Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                        SizedBox(height: 10.h),

                        // Music Preferences TextFormField
                        _buildTextField(
                          label: 'Music Preferences',
                          hint: 'Preferred music or silence',
                          controller:
                              postAnyCardController.musicPreferenceController,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Music Preference is required'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Medication TextFormField
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
                          controller:
                              postAnyCardController.medicationController,
                          maxLines: 5,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Medication is required'
                              : null,
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

                  MedicalSuppliesScreen(
                    selectedIds: postAnyCardController.selectedSupplies,
                    onSelectionChanged: (items) {
                      setState(() {
                        postAnyCardController.selectedSupplies.assignAll(items);
                      });
                    },
                  ),

                  SizedBox(height: 20.h),
                  SuturesContainer(
                    selectedIds: postAnyCardController.selectedSutures,
                    onSelectionChanged: (items) {
                      setState(() {
                        postAnyCardController.selectedSutures.assignAll(items);
                      });
                    },
                  ),
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
                          controller:
                              postAnyCardController.instrumentController,
                          maxLines: 5,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Instruments are required'
                              : null,
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
                          controller:
                              postAnyCardController.postingEquipmentController,
                          maxLines: 2,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Positioning Equipment is required'
                              : null,
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
                          controller: postAnyCardController.positionController,
                          maxLines: 2,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Prepping is required'
                              : null,
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
                          controller:
                              postAnyCardController.operativeWorkFlowController,
                          maxLines: 5,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Operative Workflow is required'
                              : null,
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
                            child: TextFormField(
                              controller:
                                  postAnyCardController.keyNotesController,
                              maxLines: 3,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Key Notes are required'
                                  : null,
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
                          onTap: postAnyCardController.pickImages,
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
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (postAnyCardController
                                  .selectedImages
                                  .isNotEmpty) ...[
                                SizedBox(height: 16.h),
                                Text(
                                  '${postAnyCardController.selectedImages.length} images selected',
                                  style: GoogleFonts.arimo(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                SizedBox(
                                  height: 100.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: postAnyCardController
                                        .selectedImages
                                        .length,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 8.w),
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              image: DecorationImage(
                                                image: FileImage(
                                                  File(
                                                    postAnyCardController
                                                        .selectedImages[index]
                                                        .path,
                                                  ),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 4.h,
                                            right: 12.w,
                                            child: GestureDetector(
                                              onTap: () {
                                                postAnyCardController
                                                    .selectedImages
                                                    .removeAt(index);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(2.w),
                                                decoration: const BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ],
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
                child: CustomElevatedButton(
                  label: widget.isPrivate ? 'Save' : 'Publish',
                  onPressed: _publish,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
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
            controller: controller,
            validator: validator,
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
