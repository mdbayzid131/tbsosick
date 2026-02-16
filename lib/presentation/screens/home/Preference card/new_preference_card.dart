import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/core/utils/validators.dart';
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

  bool _showSuppliesError = false;
  bool _showSuturesError = false;

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
    // homePageController.getSupplies();
    // homePageController.getSutures();
  }

  // Handle publish
  void _publish() {
    setState(() {
      _showSuppliesError = postAnyCardController.selectedSupplies.isEmpty;
      _showSuturesError = postAnyCardController.selectedSutures.isEmpty;
    });

    if (!_formKey.currentState!.validate() ||
        _showSuppliesError ||
        _showSuturesError) {
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
                          validator: Validators.required,
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
                          validator: Validators.required,
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
                          validator: Validators.required,
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
                          validator: Validators.required,
                        ),
                        SizedBox(height: 10.h),
                        Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                        SizedBox(height: 10.h),

                        // Contact Number TextFormField
                        _buildTextField(
                          label: 'Contact Number',
                          hint: '(555) 123-4567',
                          controller: postAnyCardController.contactController,
                          validator: Validators.phoneNumber,
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
                          validator: Validators.required,
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
                          validator: Validators.required,
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
                        if (items.isNotEmpty) {
                          _showSuppliesError = false;
                        }
                      });
                    },
                  ),
                  if (_showSuppliesError)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, left: 16.w),
                      child: Text(
                        'Medical Supplies are required',
                        style: GoogleFonts.arimo(
                          color: Colors.red,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),

                  SizedBox(height: 20.h),
                  SuturesContainer(
                    selectedIds: postAnyCardController.selectedSutures,
                    onSelectionChanged: (items) {
                      setState(() {
                        postAnyCardController.selectedSutures.assignAll(items);
                        if (items.isNotEmpty) {
                          _showSuturesError = false;
                        }
                      });
                    },
                  ),
                  if (_showSuturesError)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, left: 16.w),
                      child: Text(
                        'Sutures are required',
                        style: GoogleFonts.arimo(
                          color: Colors.red,
                          fontSize: 12.sp,
                        ),
                      ),
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
                          validator: Validators.required,
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
                          validator: Validators.required,
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
                          validator: Validators.required,
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
                          validator: Validators.required,
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
                              validator: Validators.required,
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

                        // Image Grid
                        // Image Grid
                        Obx(() {
                          final images = postAnyCardController.selectedImages;

                          // If no images are selected, show the full-width centered Add button
                          if (images.isEmpty) {
                            return GestureDetector(
                              onTap: postAnyCardController.pickImages,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F7),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                    width: 1.w,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 48.sp,
                                      color: const Color(0xFF9945FF),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      'Add Photos',
                                      style: GoogleFonts.arimo(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF9945FF),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Tap to select from library',
                                      style: GoogleFonts.arimo(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF8E8E93),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // If images are selected, show the GridView
                          final bool showAddButton = images.length < 5;
                          final int itemCount = showAddButton
                              ? images.length + 1
                              : images.length;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12.w,
                                  mainAxisSpacing: 12.h,
                                  childAspectRatio: 1.0,
                                ),
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              // If add button is shown, it's at index 0
                              if (showAddButton && index == 0) {
                                return GestureDetector(
                                  onTap: postAnyCardController.pickImages,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F7),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 32.sp,
                                          color: const Color(0xFF9945FF),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          'Add',
                                          style: GoogleFonts.arimo(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF9945FF),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              // Calculate image index
                              final imageIndex = showAddButton
                                  ? index - 1
                                  : index;
                              final imageFile = File(images[imageIndex].path);

                              return Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      image: DecorationImage(
                                        image: FileImage(imageFile),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4.r,
                                          offset: Offset(0, 2.h),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 4.h,
                                    right: 4.w,
                                    child: GestureDetector(
                                      onTap: () {
                                        postAnyCardController.selectedImages
                                            .removeAt(imageIndex);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.w),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }),
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
                child: Obx(
                  () => CustomElevatedButton(
                    label: widget.isPrivate ? 'Save' : 'Publish',
                    isLoading: postAnyCardController.isLoading.value,
                    onPressed: _publish,
                  ),
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
