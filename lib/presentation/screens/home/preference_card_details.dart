import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:tbsosick/presentation/screens/home/controller/prefrance_card_ditails_controller.dart';

class PreferenceCardDetails extends StatefulWidget {
  const PreferenceCardDetails({super.key});

  @override
  State<PreferenceCardDetails> createState() => _PreferenceCardDetailsState();
}

class _PreferenceCardDetailsState extends State<PreferenceCardDetails> {
  final PrefranceCardDetailsController controller =
      Get.find<PrefranceCardDetailsController>();

  late String cardId;

  @override
  void initState() {
    cardId = Get.arguments?['cardId'] ?? '';
    if (cardId.isNotEmpty) {
      controller.getCardDetails(cardId: cardId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100.w,
        leading: Center(
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Row(
              children: [
                SizedBox(width: 10.w),
                Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 17.sp,
                  color: Color(0xff9945FF),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Back',
                  style: GoogleFonts.arimo(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff9945FF),
                  ),
                ),
              ],
            ),
          ),
        ),

        backgroundColor: const Color(0xffffffff),
        actions: [
          InkWell(
            onTap: () {
              controller.copyCardId(cardId: cardId);
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Color(0xffF2F2F7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.copy_outlined,
                size: 22.sp,
                color: Color(0xff9945FF),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Obx(
            () => controller.cardDetails.value?.published == true
                ? InkWell(
                    onTap: () {
                      controller.shareCard();
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Color(0xffF2F2F7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.share_outlined,
                        size: 22.sp,
                        color: Color(0xff9945FF),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          SizedBox(width: 16.w),
          InkWell(
            onTap: () {
              controller.downloadCard(cardId: cardId);
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Color(0xff9945FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.file_download_outlined,
                size: 22.sp,
                color: Color(0xffffffff),
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        top: false,

        child: Obx(() {
          if (controller.isLoading.value) {
            return SizedBox(
              height: ScreenUtil().screenHeight * 0.8,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          if (controller.cardDetails.value == null) {
            return SizedBox(
              height: ScreenUtil().screenHeight * 0.8,
              child: const Center(child: Text('No details found')),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card - Doctor name and procedure title
                _buildHeaderCard(),

                SizedBox(height: 16.h),

                // Surgeon Information Card
                _buildSurgeonInformationCard(),

                SizedBox(height: 16.h),

                // Medication Card
                _buildMedicationCard(),

                SizedBox(height: 16.h),

                // All Supplies Card
                _buildAllSuppliesCard(),

                SizedBox(height: 16.h),

                // Sutures Card
                _buildSuturesCard(),

                SizedBox(height: 16.h),

                // Instruments Card
                _buildInstrumentsCard(),

                SizedBox(height: 16.h),

                // Positioning Card
                _buildPositioningCard(),

                SizedBox(height: 16.h),

                // Prepping / Shaving Card
                _buildPreppingCard(),

                SizedBox(height: 16.h),

                // Key Notes Card
                _buildKeyNotesCard(),

                SizedBox(height: 20.h),

                // Photo Library
                _buildPhotoLibrary(),

                SizedBox(height: 30.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Header Card with doctor name and procedure
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          // Title with star icon
          Text(
            controller.cardDetails.value?.cardTitle ?? '',
            style: GoogleFonts.arimo(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
            ),
          ),
          SizedBox(height: 12.h),
          // Downloads and updated date
          Row(
            children: [
              controller.cardDetails.value?.published == true
                  ? Text(
                      '${controller.cardDetails.value?.downloadCount ?? 0} downloads',
                      style: GoogleFonts.arimo(
                        fontSize: 15.sp,
                        color: const Color(0xFF8E8E93),
                      ),
                    )
                  : const SizedBox.shrink(),
              Text(
                ' •  Updated ${controller.cardDetails.value?.updatedAt.day.toString()}/${controller.cardDetails.value?.updatedAt.month.toString()}/${controller.cardDetails.value?.updatedAt.year.toString() ?? ''}',
                style: GoogleFonts.arimo(
                  fontSize: 15.sp,
                  color: const Color(0xFF8E8E93),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Surgeon Information Card
  Widget _buildSurgeonInformationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          // Section header
          Text(
            'SURGEON INFORMATION',
            style: GoogleFonts.arimo(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8E8E93),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 16.h),
          // Name
          _buildInfoLabel('Name'),
          SizedBox(height: 4.h),
          Text(
            controller.cardDetails.value?.surgeon.fullName ?? '',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF000000),
            ),
          ),
          SizedBox(height: 16.h),
          // Specialty
          _buildInfoLabel('Specialty'),
          SizedBox(height: 4.h),
          Text(
            controller.cardDetails.value?.surgeon.specialty ?? '',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff000000),
            ),
          ),
          SizedBox(height: 16.h),
          // Contact
          _buildInfoLabel('Contact'),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 17.sp,
                color: const Color(0xFF8B5CF6),
              ),
              SizedBox(width: 6.w),
              Text(
                controller.cardDetails.value?.surgeon.contactNumber ?? '',
                style: GoogleFonts.arimo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Music Preferences
          _buildInfoLabel('Music Preferences'),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                Icons.music_note_outlined,
                size: 17.sp,
                color: const Color(0xFF000000),
              ),
              SizedBox(width: 6.w),
              Text(
                controller.cardDetails.value?.surgeon.musicPreference ?? '',
                style: GoogleFonts.arimo(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Hand Preference
          _buildInfoLabel('Hand Preference'),
          SizedBox(height: 4.h),
          Row(
            children: [
              Text('👈', style: TextStyle(fontSize: 17.sp)),
              SizedBox(width: 6.w),
              Text(
                controller.cardDetails.value?.surgeon.handPreference ?? '',
                style: GoogleFonts.arimo(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Medication Card
  Widget _buildMedicationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
            'Medication',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
            ),
          ),
          SizedBox(height: 12.h),
          // Medication list
          Text(
            controller.cardDetails.value?.medication ?? '',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              height: 1.6,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  // All Supplies Card
  Widget _buildAllSuppliesCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          // Section header
          Text(
            'All Supplies',
            style: GoogleFonts.arimo(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF8E8E93),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 12.h),
          // Supply items
          Obx(() {
            if (controller.cardDetails.value?.supplies.isEmpty ?? true) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 235, 243),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1.w,
                  ),
                ),
                child: Center(
                  child: Text(
                    'No supplies found',
                    style: GoogleFonts.arimo(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.cardDetails.value?.supplies.length ?? 0,
              itemBuilder: (context, index) {
                final supply = controller.cardDetails.value?.supplies[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildSupplyItem(supply?.name ?? '', 1),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // Sutures Card
  Widget _buildSuturesCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          // Section header
          Text(
            'Sutures',
            style: GoogleFonts.arimo(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF8E8E93),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 12.h),
          // Suture items
          Obx(() {
            if (controller.cardDetails.value?.sutures.isEmpty ?? true) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 235, 243),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1.w,
                  ),
                ),
                child: Center(
                  child: Text(
                    'No sutures found',
                    style: GoogleFonts.arimo(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.cardDetails.value?.sutures.length ?? 0,
              itemBuilder: (context, index) {
                final suture = controller.cardDetails.value?.sutures[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildSupplyItem(suture?.name ?? '', 1),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // Instruments Card
  Widget _buildInstrumentsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
            'Instruments',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
            ),
          ),
          SizedBox(height: 12.h),
          // Instruments list
          Text(
            controller.cardDetails.value?.instruments ?? '',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              height: 1.6,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  // Positioning Card
  Widget _buildPositioningCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
            'Positioning',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
            ),
          ),
          SizedBox(height: 12.h),
          // Equipment / Placement
          _buildInfoLabel('Equipment / Placement'),
          SizedBox(height: 4.h),
          Text(
            controller.cardDetails.value?.positioningEquipment ?? '',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              color: const Color(0xFF000000),
            ),
          ),
          SizedBox(height: 12.h),
          // Patient Position
          _buildInfoLabel('Patient Position'),
          SizedBox(height: 4.h),
          Text(
            controller.cardDetails.value?.positioningEquipment ?? '',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  // Prepping / Shaving Card
  Widget _buildPreppingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
            'Prepping / Shaving',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
            ),
          ),
          SizedBox(height: 12.h),
          // Prepping details
          Text(
            controller.cardDetails.value?.prepping ?? '',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              height: 1.6,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  // Key Notes Card (Yellow background)
  Widget _buildKeyNotesCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFFFFF3CD), const Color(0xFFFFE69C)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFFFE082), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Notes header with warning icon
          Text(
            '⚠️ Key Notes',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
            ),
          ),
          SizedBox(height: 12.h),
          // Key notes content
          Text(
            controller.cardDetails.value?.keyNotes ?? '',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              height: 1.6,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for info labels (small gray text)
  Widget _buildInfoLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.arimo(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF8E8E93),
      ),
    );
  }

  // Helper widget for supply items with quantity
  Widget _buildSupplyItem(String name, int quantity) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF000000),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '× $quantity',
            style: GoogleFonts.arimo(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9945FF),
            ),
          ),
        ],
      ),
    );
  }

  // Photo Library Section
  Widget _buildPhotoLibrary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photo library',
          style: GoogleFonts.arimo(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF000000),
          ),
        ),
        SizedBox(height: 16.h),
        Obx(() {
          if (controller.cardDetails.value?.photoLibrary.isEmpty ?? true) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 235, 235, 243),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
              ),
              child: Center(
                child: Text(
                  'No photos found',
                  style: GoogleFonts.arimo(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.cardDetails.value?.photoLibrary.length ?? 0,
            itemBuilder: (context, index) {
              final photo = controller.cardDetails.value?.photoLibrary[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.network(
                    photo ?? '',
                    width: double.infinity,
                    height: 250.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 250.h,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 250.h,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
