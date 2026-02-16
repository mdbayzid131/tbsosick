import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/data/models/supplies_model.dart';
import 'package:tbsosick/presentation/controllers/homepgeController.dart';

class MedicalSuppliesScreen extends StatefulWidget {
  final List<String> selectedIds;
  final Function(List<String>) onSelectionChanged;
  const MedicalSuppliesScreen({
    super.key,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  @override
  State<MedicalSuppliesScreen> createState() => _MedicalSuppliesScreenState();
}

class _MedicalSuppliesScreenState extends State<MedicalSuppliesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        homePageController.getSupplies(search: _searchController.text);
      }
    });
    setState(() {});
  }

  List<SuppliesModel> get filteredSupplies {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return [];
    return homePageController.supplies
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  void removeItem(String id) {
    List<String> newList = List.from(widget.selectedIds);
    newList.remove(id);
    widget.onSelectionChanged(newList);
  }

  void addItem(String id) {
    if (!widget.selectedIds.contains(id)) {
      List<String> newList = List.from(widget.selectedIds);
      newList.add(id);
      widget.onSelectionChanged(newList);
    }
  }

  final HomePageController homePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Supplies',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff000000),
                  ),
                ),
                Icon(Icons.search, color: const Color(0xff9945FF), size: 28.sp),
              ],
            ),
            SizedBox(height: 24.h),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffF2F2F7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search thousands of supplies...',
                  hintStyle: GoogleFonts.arimo(
                    fontSize: 16.sp,
                    color: const Color(0xff8E8E93),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xff8E8E93),
                    size: 20.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
                style: GoogleFonts.arimo(fontSize: 16.sp, color: Colors.black),
              ),
            ),

            // Search Results or No Results
            Obx(() {
              // Show loading indicator if supplies are being fetched
              if (homePageController.isSuppliesLoading.value) {
                return Column(
                  children: [
                    SizedBox(height: 24.h),
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff9945FF),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                );
              }

              homePageController.supplies.length; // Register dependency
              final results = filteredSupplies;

              if (_searchController.text.isNotEmpty) {
                if (results.isNotEmpty) {
                  return Column(
                    children: [
                      SizedBox(height: 8.h),
                      Container(
                        constraints: BoxConstraints(maxHeight: 250.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xff9945FF).withOpacity(0.3),
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final item = results[index];
                            final isSelected = widget.selectedIds.contains(
                              item.id,
                            );
                            return InkWell(
                              onTap: () {
                                if (isSelected) {
                                  removeItem(item.id);
                                } else {
                                  addItem(item.id);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(
                                          0xff9945FF,
                                        ).withOpacity(0.05)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade100,
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: TextStyle(
                                          color: isSelected
                                              ? const Color(0xff9945FF)
                                              : Colors.grey.shade700,
                                          fontSize: 15.sp,
                                          fontWeight: isSelected
                                              ? FontWeight.w500
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.add,
                                      color: isSelected
                                          ? const Color(0xff9945FF)
                                          : Colors.grey.shade400,
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  // No results found
                  return Column(
                    children: [
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2.w,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Center(
                          child: Text(
                            'No supplies found',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
              return const SizedBox.shrink();
            }),

            SizedBox(height: 24.h),

            // Selected Items
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xff9945FF).withOpacity(0.05),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Items (${widget.selectedIds.length})',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff9945FF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  if (widget.selectedIds.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          'No item selected',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: widget.selectedIds.map((id) {
                        // Find the name for this ID from controller's full list
                        final item = homePageController.supplies.firstWhere(
                          (element) => element.id == id,
                          orElse: () => SuppliesModel(id: id, name: 'Unknown'),
                        );
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xff9945FF).withOpacity(0.3),
                              width: 2.w,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4.r,
                                offset: Offset(0, 2.h),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    color: const Color(0xff9945FF),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              InkWell(
                                onTap: () => removeItem(id),
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xff9945FF,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16.sp,
                                    color: const Color(0xff9945FF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Info Text
            Container(
              padding: EdgeInsets.only(top: 16.h),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200, width: 1.w),
                ),
              ),
              child: Center(
                child: Text(
                  'Search from thousands of medical supplies',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
