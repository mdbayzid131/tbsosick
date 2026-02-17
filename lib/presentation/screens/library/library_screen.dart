import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/presentation/controllers/bottom_nab_bar_controller.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';

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

  final controller = Get.find<BottomNabBarController>();
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
            tabs: [_tab1('Preference card', 0), _tab2('Private Card', 1)],
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
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                controller.searchController.value = value;
              },
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

  Widget _tab2(String text, int index) {
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

  Widget _tab1(String text, int index) {
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
          Obx(
            () => Text(
              '${controller.publicCards.length} Preference cards',
              style: GoogleFonts.arimo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
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
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.errorMessage.isNotEmpty) {
                    return Center(child: Text(controller.errorMessage.value));
                  }
                  if (controller.publicCards.isEmpty) {
                    return const Center(child: Text('No cards found'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.publicCards.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.publicCards.length) {
                        return _buildLoadMoreButton(
                          isLoading: controller.isPublicMoreLoading.value,
                          hasMore: controller.hasMorePublic.value,
                          onPressed: () => controller.loadMorePublic(),
                        );
                      }
                      final card = controller.publicCards[index];
                      return Column(
                        children: [
                          _buildProcedureCard(
                            isPrivetCard: false,
                            cardId: card.id,
                            title: card.cardTitle,
                            specialty: card.surgeonSpecialty,
                            isVerified: card.isVerified,
                            doctor: "By ${card.surgeonName}",
                            downloads: card.totalDownloads,
                            updatedTime: card.updatedAt,
                            isFavorite: false,
                          ),
                          SizedBox(height: 12.h),
                        ],
                      );
                    },
                  );
                }),
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
          // Card count
          Obx(
            () => Text(
              '${controller.privateCards.length} Private cards',
              style: GoogleFonts.arimo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Cards list
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.errorMessage.isNotEmpty) {
                    return Center(child: Text(controller.errorMessage.value));
                  }
                  if (controller.privateCards.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: const Center(
                        child: Text('No private cards found'),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.privateCards.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.privateCards.length) {
                        return _buildLoadMoreButton(
                          isLoading: controller.isPrivateMoreLoading.value,
                          hasMore: controller.hasMorePrivate.value,
                          onPressed: () => controller.loadMorePrivate(),
                        );
                      }
                      final card = controller.privateCards[index];
                      return Column(
                        children: [
                          _buildProcedureCard(
                            cardId: card.id,
                            isPrivetCard: true,
                            title: card.cardTitle,
                            specialty: card.surgeonSpecialty,
                            isVerified: card.isVerified,
                            doctor: card.surgeonName,
                            downloads: card.totalDownloads,
                            updatedTime: card.updatedAt,
                            isFavorite: false,
                          ),
                          SizedBox(height: 12.h),
                        ],
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Individual procedure card
  Widget _buildProcedureCard({
    required bool isPrivetCard,
    required String title,
    required String cardId,
    required String specialty,
    required bool isVerified,
    required String doctor,
    required int downloads,
    required DateTime updatedTime,
    required bool isFavorite,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.CARD_DETAILS, arguments: {'cardId': cardId});
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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
                if (!isPrivetCard)
                  Icon(
                    Icons.file_download_outlined,
                    color: const Color(0xFF6B7280),
                    size: 20.sp,
                  ),
                SizedBox(width: 4.w),
                if (!isPrivetCard)
                  Text(
                    downloads.toString(),
                    style: GoogleFonts.arimo(
                      fontSize: 13.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                SizedBox(width: 16.w),
                Text(
                  "updated: ${updatedTime.day}/${updatedTime.month}/${updatedTime.year}",
                  style: GoogleFonts.arimo(
                    fontSize: 13.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // 👉 এখানে download action দাও
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

  // Load more button widget
  Widget _buildLoadMoreButton({
    required bool isLoading,
    required bool hasMore,
    required VoidCallback onPressed,
  }) {
    if (!hasMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Text(
            'No more data',
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : TextButton(
                onPressed: onPressed,
                child: Text(
                  'Load More',
                  style: GoogleFonts.arimo(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
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
          child: SafeArea(
            child: SingleChildScrollView(
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
                        'Cardiac Surgery',
                        _selectedSpecialty == 'Cardiac Surgery',
                        () {
                          setModalState(() {
                            _selectedSpecialty = 'Cardiac Surgery';
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
                      _buildFilterChip(
                        'Neurosurgery',
                        _selectedSpecialty == 'Neurosurgery',
                        () {
                          setModalState(() {
                            _selectedSpecialty = 'Neurosurgery';
                          });
                        },
                      ),
                      _buildFilterChip(
                        'Plastic Surgery',
                        _selectedSpecialty == 'Plastic Surgery',
                        () {
                          setModalState(() {
                            _selectedSpecialty = 'Plastic Surgery';
                          });
                        },
                      ),
                      _buildFilterChip(
                        'Vascular Surgery',
                        _selectedSpecialty == 'Vascular Surgery',
                        () {
                          setModalState(() {
                            _selectedSpecialty = 'Vascular Surgery';
                          });
                        },
                      ),
                      _buildFilterChip(
                        'Thoracic Surgery',
                        _selectedSpecialty == 'Thoracic Surgery',
                        () {
                          setModalState(() {
                            _selectedSpecialty = 'Thoracic Surgery';
                          });
                        },
                      ),
                      _buildFilterChip(
                        'Pediatric Surgery',
                        _selectedSpecialty == 'Pediatric Surgery',
                        () {
                          setModalState(() {
                            _selectedSpecialty = 'Pediatric Surgery';
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
                        controller.specialtyFilter.value = _selectedSpecialty;
                        controller.verifiedOnlyFilter.value = _verifiedOnly;
                        controller.refreshCards();
                        Navigator.pop(context);
                      },
                      label: 'Apply Filters',
                    ),
                  ),
                ],
              ),
            ),
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
