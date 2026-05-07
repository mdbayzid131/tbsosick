import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/core/utils/validators.dart';
import 'package:tbsosick/presentation/controllers/homepgeController.dart';
import 'package:tbsosick/presentation/controllers/post_any__card_controller.dart';
import 'package:tbsosick/presentation/screens/auth_screen/quick_setup/what_your_speciality.dart';
import 'package:tbsosick/presentation/screens/home/Preference%20card/sutures_container.dart';
import 'package:tbsosick/presentation/widgets/CustomContainer.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';
import 'medical_supplies_container.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

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
              AppLocalizations.of(context)!.cancel,
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
          widget.isPrivate
              ? AppLocalizations.of(context)!.newPrivateCardTitle
              : AppLocalizations.of(context)!.newPreferenceCardTitle,
          style: GoogleFonts.arimo(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xffffffff),
        actions: [
          TextButton(
            onPressed: () => _publish(),
            child: Text(
              widget.isPrivate
                  ? AppLocalizations.of(context)!.save
                  : AppLocalizations.of(context)!.publish,
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
                            AppLocalizations.of(context)!.cardTitleLabel,
                            style: GoogleFonts.arimo(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff8E8E93),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: postAnyCardController.cardTitleController,
                          validator: (value) => Validators.minLength(
                            value,
                            3,
                            message: 'Card Title must be at least 3 characters',
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            labelStyle: GoogleFonts.arimo(
                              fontSize: 16.sp,
                              color: const Color(0xff9E9E9E),
                            ),
                            hintText: AppLocalizations.of(
                              context,
                            )!.cardTitleHint,
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
                              AppLocalizations.of(context)!.surgeonDetails,
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
                          label: AppLocalizations.of(context)!.fullNameLabel,
                          hint: AppLocalizations.of(context)!.enterFullName,
                          controller: postAnyCardController.fullNameController,
                          validator: (value) => Validators.minLength(
                            value,
                            3,
                            message: 'Full Name must be at least 3 characters',
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                        SizedBox(height: 10.h),

                        // Hand Preference TextFormField
                        _buildTextField(
                          label: AppLocalizations.of(
                            context,
                          )!.handPreferenceSurgeon,
                          hint: AppLocalizations.of(
                            context,
                          )!.enterHandPreference,
                          controller:
                              postAnyCardController.handpreferenceController,
                          validator: Validators.required,
                        ),
                        SizedBox(height: 10.h),
                        Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                        SizedBox(height: 10.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!.specialtyLabel,
                                  style: GoogleFonts.arimo(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff8E8E93),
                                  ),
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                initialValue:
                                    postAnyCardController
                                        .specialitiesController
                                        .text
                                        .isEmpty
                                    ? null
                                    : postAnyCardController
                                          .specialitiesController
                                          .text,
                                validator: (value) =>
                                    Validators.required(value),
                                isExpanded: true,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: const Color(0xff8E8E93),
                                  size: 24.sp,
                                ),
                                dropdownColor: Colors.white,
                                elevation: 8,
                                borderRadius: BorderRadius.circular(16.r),
                                items: getSpecialties(context)
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item.title,
                                        child: Text(
                                          item.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.arimo(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff8E8E93),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  postAnyCardController
                                          .specialitiesController
                                          .text =
                                      value ?? '';
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                  labelStyle: GoogleFonts.arimo(
                                    fontSize: 14.sp,
                                    color: const Color(0xff9E9E9E),
                                  ),
                                  hintText: AppLocalizations.of(
                                    context,
                                  )!.selectSpecialty,
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
                        ),
                        SizedBox(height: 10.h),
                        Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                        SizedBox(height: 10.h),

                        // Contact Number TextFormField
                        _buildTextField(
                          label: AppLocalizations.of(
                            context,
                          )!.contactNumberLabel,
                          hint: AppLocalizations.of(context)!.phonePlaceholder,
                          controller: postAnyCardController.contactController,
                          validator: Validators.phoneNumber,
                        ),
                        SizedBox(height: 10.h),
                        Divider(height: 1.5.h, color: Color(0xffEEEEEF)),
                        SizedBox(height: 10.h),

                        // Music Preferences TextFormField
                        _buildTextField(
                          label: AppLocalizations.of(context)!.musicPreferences,
                          hint: AppLocalizations.of(
                            context,
                          )!.musicPreferencesHint,
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
                            AppLocalizations.of(context)!.medication,
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
                            hintText: AppLocalizations.of(
                              context,
                            )!.medicationHint,
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
                    selectedItems: postAnyCardController.selectedSupplies,
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
                        AppLocalizations.of(context)!.medicalSuppliesRequired,
                        style: GoogleFonts.arimo(
                          color: Colors.red,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),

                  SizedBox(height: 20.h),
                  SuturesContainer(
                    selectedItems: postAnyCardController.selectedSutures,
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
                        AppLocalizations.of(context)!.suturesRequired,
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
                            AppLocalizations.of(context)!.instruments,
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
                            hintText: AppLocalizations.of(
                              context,
                            )!.instrumentsHint,
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
                            AppLocalizations.of(
                              context,
                            )!.positioningEquipmentPlacement,
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
                            hintText: AppLocalizations.of(
                              context,
                            )!.positioningEquipmentHint,
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
                            AppLocalizations.of(context)!.positioningPrepping,
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
                            hintText: AppLocalizations.of(
                              context,
                            )!.patientPositioningHint,
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
                            AppLocalizations.of(context)!.operativeWorkflow,
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
                            hintText: AppLocalizations.of(context)!.stepsOfCase,
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
                          '⚠️ ${AppLocalizations.of(context)!.keyNotes}',
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
                                hintText: AppLocalizations.of(
                                  context,
                                )!.keyNotesHint,
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
                          AppLocalizations.of(context)!.photoLibrary,
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
                                      AppLocalizations.of(context)!.addPhotos,
                                      style: GoogleFonts.arimo(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF9945FF),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.tapToSelectFromLibrary,
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
                                          AppLocalizations.of(context)!.add,
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
                    label: widget.isPrivate
                        ? AppLocalizations.of(context)!.save
                        : AppLocalizations.of(context)!.publish,
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
