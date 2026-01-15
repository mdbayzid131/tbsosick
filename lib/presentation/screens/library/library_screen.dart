import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/core/constants/image_paths.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';

import 'library_preference_card_details.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  // Tab controller for switching between Preference card and Private Card
  late TabController _tabController;

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // Filter states
  String _selectedSpecialty = 'All';
  bool _verifiedOnly = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      // এখানে indexIsChanging ব্যবহার করো না
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Show filter bottom sheet
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header section with gradient background
          _buildHeader(),

          // Tab buttons - Preference card and Private Card
          SizedBox(height: 30.h),

          // _buildTabButtons(),
          SizedBox(height: 16.h),
          TabBar(
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(Colors.transparent),

            dividerColor: Colors.transparent,
            controller: _tabController,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab1('Preference card', 0),
              Tab2('Private Card', 1),
              // _buildTabButtons('Private Card'),
            ],
          ),
          SizedBox(height: 16.h),

          // Content area
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Preference cards list
                _buildPreferenceCardsList(),
                // Private cards list (same structure, different data)
                _buildPrivateCardsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header with gradient background and search bar
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Preference Library',
            style: GoogleFonts.arimo(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          // Search bar
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.arimo(
                fontSize: 15.sp,
                color: const Color(0xFF79747E),
              ),
              decoration: InputDecoration(
                hintText: 'Search procedures...',
                hintStyle: GoogleFonts.arimo(
                  fontSize: 15.sp,
                  color: const Color(0xFF79747E),
                ),
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: const Color(0xFF8B5CF6),
                  size: 22.sp,
                ),
                suffixIcon: GestureDetector(
                  onTap: _showFilterBottomSheet,
                  child: Icon(
                    Icons.tune_outlined,
                    color: const Color(0xFF8B5CF6),
                    size: 22.sp,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab buttons for Preference card and Private Card
  // Widget _buildTabButtons(String text, int index) {
  //   final isSelected = _tabController.index == index;
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 20.w),
  //     child: Row(
  //       children: [
  //         // Preference card tab
  //         Expanded(
  //           child: GestureDetector(
  //             onTap: () {
  //               // _tabController.animateTo(0);
  //               // setState(() {});
  //             },
  //             child: Tab1(isSelected),
  //           ),
  //         ),
  //         SizedBox(width: 12.w),
  //         // Private Card tab
  //         Expanded(
  //           child: GestureDetector(
  //             onTap: () {
  //               _tabController.animateTo(1);
  //               setState(() {});
  //             },
  //             child: Tab2(isSelected),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Container Tab2(String text, int index) {
    final bool isSelected = _tabController.index == index;
    return Container(
      height: 90.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: isSelected
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff6950A7), Color(0xfF9746FB)],
              )
            : null,
        color: !isSelected ? Color(0xffCFC8DF) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                color: !isSelected ? Color(0xffD9D3E5) : Color(0xff9E6DE4),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.description_outlined,
                color: !isSelected ? Color(0xff6D6D6D) : Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: Text(
                'Private Card',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: !isSelected ? Color(0xff6D6D6D) : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container Tab1(String text, int index) {
    final bool isSelected = _tabController.index == index;
    return Container(
      height: 90.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: isSelected
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff6950A7), Color(0xfF9746FB)],
              )
            : null,
        color: !isSelected ? Color(0xffCFC8DF) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                color: !isSelected ? Color(0xffD9D3E5) : Color(0xff9E6DE4),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.description_outlined,
                color: !isSelected ? Color(0xff6D6D6D) : Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: Text(
                'Preference card',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: !isSelected ? Color(0xff6D6D6D) : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Preference cards list
  Widget _buildPreferenceCardsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card count
          Text(
            '3 Preference cards',
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 12.h),
          // Cards list
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                /// No Cards Found
                /*Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 30.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, color: Color(0xFF8B5CF6), size: 40.sp),
                      SizedBox(height: 16.h),
                      Text(
                        'No cards found',
                        style: GoogleFonts.arimo(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8E8E93),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Try adjusting your filters',
                        style: GoogleFonts.arimo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFC6C6C8),
                        ),
                      ),
                    ],
                  ),
                ),*/
                SizedBox(height: 12.h),
                _buildProcedureCard(
                  title: 'Total Knee Replacement',
                  specialty: 'Orthopedic',
                  isVerified: true,
                  duration: '2-3 hours',
                  doctor: 'By Sarah Johnson',
                  downloads: 236,
                  updatedTime: 'Updated Just now',
                  isFavorite: true,
                ),
                SizedBox(height: 12.h),
                _buildProcedureCard(
                  title: 'Coronary Artery Bypass',
                  specialty: 'Cardiothoracic',
                  isVerified: true,
                  duration: '4-6 hours',
                  doctor: 'By Michael Chen',
                  downloads: 236,
                  updatedTime: 'Updated Just now',
                  isFavorite: false,
                ),
                SizedBox(height: 12.h),
                _buildProcedureCard(
                  title: 'Laparoscopic Cholecystectomy',
                  specialty: 'General Surgery',
                  isVerified: false,
                  duration: '1-2 hours',
                  doctor: 'By Emily Rodriguez',
                  downloads: 236,
                  updatedTime: 'Updated Just now',
                  isFavorite: false,
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Private cards list (same structure)
  Widget _buildPrivateCardsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '0 Private cards',
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(height: 12.h),
          // Cards list
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildProcedureCard(
                  title: 'Total Knee Replacement',
                  specialty: 'Orthopedic',
                  isVerified: true,
                  duration: '2-3 hours',
                  doctor: 'By Sarah Johnson',
                  downloads: 236,
                  updatedTime: 'Updated Just now',
                  isFavorite: true,
                ),
                SizedBox(height: 12.h),
                _buildProcedureCard(
                  title: 'Coronary Artery Bypass',
                  specialty: 'Cardiothoracic',
                  isVerified: true,
                  duration: '4-6 hours',
                  doctor: 'By Michael Chen',
                  downloads: 236,
                  updatedTime: 'Updated Just now',
                  isFavorite: false,
                ),
                SizedBox(height: 12.h),
                _buildProcedureCard(
                  title: 'Laparoscopic Cholecystectomy',
                  specialty: 'General Surgery',
                  isVerified: false,
                  duration: '1-2 hours',
                  doctor: 'By Emily Rodriguez',
                  downloads: 236,
                  updatedTime: 'Updated Just now',
                  isFavorite: false,
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Individual procedure card
  Widget _buildProcedureCard({
    required String title,
    required String specialty,
    required bool isVerified,
    required String duration,
    required String doctor,
    required int downloads,
    required String updatedTime,
    required bool isFavorite,
  }) {
    return GestureDetector(
      onTap: () {
        // 👉 এখানে নতুন পেজে যাওয়ার কোড দাও
        Get.to(LibraryPreferenceCardDetails());
      },
      child: Container(
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
            // Title and favorite icon
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // 👉 এখানে favorite action দাও
                    print("Favorite tapped for $title");
                  },
                  child: Container(
                    height: 36.w,
                    width: 36.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8DEF8),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Icon(
                      isFavorite ? Icons.star : Icons.star_outline,
                      color: isFavorite
                          ? const Color(0xFFFFB800)
                          : const Color(0xFF9CA3AF),
                      size: 22.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Tags row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    specialty,
                    style: GoogleFonts.arimo(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6750A4),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                if (isVerified) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: const Color(0xFF10B981),
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Verified',
                          style: GoogleFonts.arimo(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: const Color(0xFF6B7280),
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      duration,
                      style: GoogleFonts.arimo(
                        fontSize: 13.sp,
                        color: const Color(0xFF79747E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Doctor name
            Text(
              doctor,
              style: GoogleFonts.arimo(
                fontSize: 13.sp,
                color: const Color(0xFF79747E),
              ),
            ),
            SizedBox(height: 12.h),
            Divider(height: 1.5.h, color: const Color(0xFFE7E0EC)),
            SizedBox(height: 12.h),

            // Bottom row
            Row(
              children: [
                Icon(
                  Icons.file_download_outlined,
                  color: const Color(0xFF6B7280),
                  size: 20.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  downloads.toString(),
                  style: GoogleFonts.arimo(
                    fontSize: 13.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  updatedTime,
                  style: GoogleFonts.arimo(
                    fontSize: 13.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // 👉 এখানে download action দাও
                    print("Download tapped for $title");
                  },
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6750A4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.file_download_outlined,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Filter bottom sheet
  Widget _buildFilterBottomSheet() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              // Title
              Text(
                'Filters',
                style: GoogleFonts.arimo(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1C1B1F),
                ),
              ),
              SizedBox(height: 20.h),
              // Specialty section
              Text(
                'SPECIALTY',
                style: GoogleFonts.arimo(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9CA3AF),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 12.h),
              // Specialty chips
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _buildFilterChip('All', _selectedSpecialty == 'All', () {
                    setModalState(() {
                      _selectedSpecialty = 'All';
                    });
                  }),
                  _buildFilterChip(
                    'Orthopedic Surgery',
                    _selectedSpecialty == 'Orthopedic Surgery',
                    () {
                      setModalState(() {
                        _selectedSpecialty = 'Orthopedic Surgery';
                      });
                    },
                  ),
                  _buildFilterChip(
                    'Cardiothoracic Surgery',
                    _selectedSpecialty == 'Cardiothoracic Surgery',
                    () {
                      setModalState(() {
                        _selectedSpecialty = 'Cardiothoracic Surgery';
                      });
                    },
                  ),
                  _buildFilterChip(
                    'General Surgery',
                    _selectedSpecialty == 'General Surgery',
                    () {
                      setModalState(() {
                        _selectedSpecialty = 'General Surgery';
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // Verified Only toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Verified Only',
                    style: GoogleFonts.arimo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1C1B1F),
                    ),
                  ),
                  Switch(
                    value: _verifiedOnly,
                    onChanged: (value) {
                      setModalState(() {
                        _verifiedOnly = value;
                      });
                    },
                    activeThumbColor: const Color(0xFF8B5CF6),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // Apply Filters button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: CustomElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: 'Apply Filters',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Filter chip widget
  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.arimo(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF1C1B1F),
          ),
        ),
      ),
    );
  }
}
