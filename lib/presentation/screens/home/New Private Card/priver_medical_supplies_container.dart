import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/image_paths.dart';

class PriverMedicalSuppliesContainer extends StatefulWidget {
  const PriverMedicalSuppliesContainer({super.key});

  @override
  State<PriverMedicalSuppliesContainer> createState() =>
      _PriverMedicalSuppliesContainerState();
}

class _PriverMedicalSuppliesContainerState extends State<PriverMedicalSuppliesContainer> {
  // Selected supplies
  final Set<String> _selectedSupplies = {};

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // Custom supply controller
  final TextEditingController _customSupplyController = TextEditingController();

  // Search field visibility
  bool _isSearchVisible = false;

  // All supplies list (40-50 items)
  final List<String> _allSupplies = [
    'Raytex Sponges',
    'Bone Cement',
    'Specimen Bag',
    'Surgical Markers',
    'Drainage Tubes',
    'Laparoscopic',
    'Orthopaedic',
    'Cardiovascular',
    'Sutures',
    'Catheters',
    'Syringes',
    'Needles',
    'Gauze Pads',
    'Bandages',
    'Gloves',
    'Masks',
    'Gowns',
    'Scalpels',
    'Forceps',
    'Scissors',
    'Retractors',
    'Clamps',
    'Staples',
    'Tapes',
    'Dressings',
    'IV Sets',
    'Blood Bags',
    'Test Tubes',
    'Petri Dishes',
    'Culture Media',
    'Disinfectants',
    'Antiseptics',
    'Thermometers',
    'Stethoscopes',
    'BP Monitors',
    'Oximeters',
    'Nebulizers',
    'Intubation Kits',
    'Tracheostomy Tubes',
    'Chest Tubes',
    'NG Tubes',
    'Foley Catheters',
    'Dialysis Sets',
    'Anesthesia Masks',
    'Oxygen Masks',
    'Ventilator Tubes',
    'ECG Electrodes',
    'Defibrillator Pads',
    'Tourniquets',
    'Splints',
  ];

  // Filtered supplies based on search
  List<String> _filteredSupplies = [];

  // Number of items to show initially
  final int _initialDisplayCount = 12;

  @override
  void initState() {
    super.initState();
    _filteredSupplies = _allSupplies.take(_initialDisplayCount).toList();
    _searchController.addListener(_filterSupplies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customSupplyController.dispose();
    super.dispose();
  }

  // Get display supplies - combines selected items with filtered results
  List<String> _getDisplaySupplies() {
    final Set<String> displaySet = {};

    // Always show selected items first
    displaySet.addAll(_selectedSupplies);

    // Add filtered supplies
    displaySet.addAll(_filteredSupplies);

    return displaySet.toList();
  }

  // Filter supplies based on search query
  void _filterSupplies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSupplies = _allSupplies.take(_initialDisplayCount).toList();
      } else {
        _filteredSupplies = _allSupplies
            .where((supply) => supply.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  // Toggle supply selection
  void _toggleSupply(String supply) {
    setState(() {
      if (_selectedSupplies.contains(supply)) {
        _selectedSupplies.remove(supply);
      } else {
        _selectedSupplies.add(supply);
      }
    });
  }

  // Add custom supply
  void _addCustomSupply() {
    final customSupply = _customSupplyController.text.trim();
    if (customSupply.isNotEmpty) {
      setState(() {
        // Add to all supplies list if not already present
        if (!_allSupplies.contains(customSupply)) {
          _allSupplies.insert(0, customSupply); // Insert at the beginning
        }
        // Select it automatically
        _selectedSupplies.add(customSupply);
        // Clear the field
        _customSupplyController.clear();
        // Update filtered supplies to show the new item
        if (_searchController.text.isEmpty) {
          _filteredSupplies = _allSupplies.take(_initialDisplayCount).toList();
        } else {
          _filterSupplies();
        }
      });

      // // Show a confirmation message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       'Added "$customSupply"',
      //       style: GoogleFonts.arimo(),
      //     ),
      //     duration: const Duration(seconds: 2),
      //     backgroundColor: const Color(0xFF8B5CF6),
      //   ),
      // );
    }
  }

  // Toggle search visibility
  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size using ScreenUtil
    final screenWidth = ScreenUtil().screenWidth;
    final screenHeight = ScreenUtil().screenHeight;
    final isTablet = screenWidth > 600;

    // Get supplies to display
    final displaySupplies = _getDisplaySupplies();

    return Container(
      width: isTablet ? 420.w : screenWidth * 0.95,
      padding: EdgeInsets.all(isTablet ? 24.w : 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with title and search icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Supplies',
                style: GoogleFonts.arimo(
                  fontSize: isTablet ? 20.sp : 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3142),
                ),
              ),
              GestureDetector(
                onTap: _toggleSearch,
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: _isSearchVisible
                      ? Icon(
                          Icons.close,
                          color: const Color(0xFF8B5CF6),
                          size: 24.sp,
                        )
                      : SvgPicture.asset(
                          ImagePaths.searchIcon,
                          height: 20.w,
                          width: 20.w,
                          fit: BoxFit.scaleDown,
                        ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Search field - shows when search icon is clicked
          if (_isSearchVisible)
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: GoogleFonts.arimo(
                  fontSize: 14.sp,
                  color: const Color(0xFF2D3142),
                ),
                decoration: InputDecoration(
                  hintText: 'Search supplies...',
                  hintStyle: GoogleFonts.arimo(
                    fontSize: 14.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFF9CA3AF),
                    size: 20.sp,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: const Color(0xFF9CA3AF),
                            size: 20.sp,
                          ),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),

          // Show selected count if any items are selected
          if (_selectedSupplies.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Text(
                '${_selectedSupplies.length} selected',
                style: GoogleFonts.arimo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ),

          // Supplies grid - wrapping in SingleChildScrollView for scrollable content
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: isTablet ? 400.h : 300.h),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: displaySupplies.map((supply) {
                  final isSelected = _selectedSupplies.contains(supply);

                  return GestureDetector(
                    onTap: () => _toggleSupply(supply),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF8B5CF6).withOpacity(0.1)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF8B5CF6)
                              : Colors.transparent,
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon - shows checkmark when selected, plus when not
                          Icon(
                            isSelected ? Icons.check : Icons.add,
                            size: 16.sp,
                            color: const Color(0xFF8B5CF6),
                          ),
                          SizedBox(width: 6.w),
                          // Supply name
                          Text(
                            supply,
                            style: GoogleFonts.arimo(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8B5CF6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Add custom supply field with button
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextField(
                    controller: _customSupplyController,
                    style: GoogleFonts.arimo(
                      fontSize: 14.sp,
                      color: const Color(0xFF2D3142),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add custom supply',
                      hintStyle: GoogleFonts.arimo(
                        fontSize: 14.sp,
                        color: const Color(0xFF9CA3AF),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    onSubmitted: (_) => _addCustomSupply(),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Add button
              GestureDetector(
                onTap: _addCustomSupply,
                child: Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9945FF),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 28.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
