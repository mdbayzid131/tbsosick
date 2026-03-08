import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/l10n/app_localizations.dart';
import 'package:tbsosick/data/models/supplies_model.dart';
import 'package:tbsosick/presentation/controllers/homepgeController.dart';
import 'package:tbsosick/presentation/controllers/post_any__card_controller.dart';

class SuturesContainer extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final Function(List<Map<String, dynamic>>) onSelectionChanged;

  const SuturesContainer({
    super.key,
    required this.selectedItems,
    required this.onSelectionChanged,
  });

  @override
  State<SuturesContainer> createState() => _SuturesContainerState();
}

class _SuturesContainerState extends State<SuturesContainer> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      homePageController.loadMoreSutures(search: _searchController.text);
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        homePageController.getSutures(search: _searchController.text);
      }
    });
    setState(() {});
  }

  final HomePageController homePageController = Get.find();
  final PostAnyCardController postAnyCardController = Get.find();

  List<SuppliesModel> get filteredSutures {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return [];
    return homePageController.sutures;
  }

  void removeItem(String id) {
    List<Map<String, dynamic>> newList = List.from(widget.selectedItems);
    newList.removeWhere((element) => element['name'] == id);
    postAnyCardController.selectedSuturesNames.remove(id);
    widget.onSelectionChanged(newList);
  }

  void updateQuantity(String id, int delta) {
    List<Map<String, dynamic>> newList = List.from(widget.selectedItems);
    final index = newList.indexWhere((element) => element['name'] == id);
    if (index != -1) {
      int newQty = (newList[index]['quantity'] as int) + delta;
      if (newQty > 0) {
        newList[index]['quantity'] = newQty;
        widget.onSelectionChanged(newList);
      }
    }
  }

  void addItem(String id, String name) {
    if (!widget.selectedItems.any((element) => element['name'] == id)) {
      List<Map<String, dynamic>> newList = List.from(widget.selectedItems);
      newList.add({'name': id, 'quantity': 1});
      postAnyCardController.selectedSuturesNames[id] = name;
      widget.onSelectionChanged(newList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            l10n.sutures,
            style: GoogleFonts.arimo(
              color: Colors.grey.shade800,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        // Search Bar - Premium Design
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _searchFocusNode.hasFocus
                  ? const Color(0xff9945FF).withOpacity(0.5)
                  : const Color(0xffE5E7EB),
              width: 1.5.w,
            ),
            boxShadow: _searchFocusNode.hasFocus
                ? [
                    BoxShadow(
                      color: const Color(0xff9945FF).withOpacity(0.1),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: l10n.searchSuturesHint,
              hintStyle: GoogleFonts.arimo(
                color: Colors.grey.shade400,
                fontSize: 15.sp,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: _searchFocusNode.hasFocus
                    ? const Color(0xff9945FF)
                    : Colors.grey.shade400,
                size: 22.sp,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear_rounded, size: 20.sp),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
            ),
            style: GoogleFonts.arimo(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Search Results Section
        Obx(() {
          if (homePageController.isSuturesLoading.value) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff9945FF),
                  strokeWidth: 3,
                ),
              ),
            );
          }

          if (_searchController.text.isNotEmpty) {
            final results = filteredSutures;
            final query = _searchController.text.trim().toLowerCase();
            final exactMatch = results.any(
              (element) => element.name.toLowerCase() == query,
            );
            return Column(
              children: [
                SizedBox(height: 8.h),
                Container(
                  constraints: BoxConstraints(maxHeight: 350.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xffF2F2F7),
                      width: 1.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15.r,
                        offset: Offset(0, 5.h),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount:
                        results.length +
                        (exactMatch ? 0 : 1) +
                        (homePageController.isSuturesMoreLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < results.length) {
                        final item = results[index];
                        final isSelected = widget.selectedItems.any(
                          (element) => element['name'] == item.id,
                        );

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => isSelected
                                ? removeItem(item.id)
                                : addItem(item.id, item.name),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xff9945FF).withOpacity(0.04)
                                    : null,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade50,
                                    width: 1.w,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: GoogleFonts.arimo(
                                        color: isSelected
                                            ? const Color(0xff9945FF)
                                            : Colors.grey.shade800,
                                        fontSize: 15.sp,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  AnimatedScale(
                                    scale: isSelected ? 1.0 : 0.8,
                                    duration: const Duration(milliseconds: 200),
                                    child: CircleAvatar(
                                      radius: 12.r,
                                      backgroundColor: isSelected
                                          ? const Color(0xff9945FF)
                                          : Colors.grey.shade100,
                                      child: Icon(
                                        isSelected ? Icons.check : Icons.add,
                                        size: 14.sp,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (!exactMatch && index == results.length) {
                        // Custom Addition Tile
                        final customName = _searchController.text.trim();
                        final isSelected = widget.selectedItems.any(
                          (element) => element['name'] == customName,
                        );

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => isSelected
                                ? removeItem(customName)
                                : addItem(customName, customName),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xff9945FF).withOpacity(0.04)
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      l10n.addAsCustom(customName),
                                      style: GoogleFonts.arimo(
                                        fontSize: 15.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: const Color(0xff9945FF),
                                    size: 22.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.all(16.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xff9945FF),
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),

        SizedBox(height: 24.h),

        // Selected Items Section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: const Color(0xffF9FAFB),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xffF2F2F7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.selectedItems.isEmpty
                        ? l10n.noItemSelected
                        : l10n.selectedWithCount(widget.selectedItems.length),
                    style: GoogleFonts.arimo(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  if (widget.selectedItems.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        postAnyCardController.selectedSuturesNames.clear();
                        widget.onSelectionChanged([]);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.clearAll,
                        style: GoogleFonts.arimo(
                          color: const Color(0xff9945FF),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              if (widget.selectedItems.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      l10n.noItemSelected,
                      style: GoogleFonts.arimo(
                        color: Colors.grey.shade400,
                        fontSize: 14.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.selectedItems.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final selectedItem = widget.selectedItems[index];
                    final String id = selectedItem['name'];
                    final int quantity = selectedItem['quantity'] ?? 1;

                    final itemName =
                        postAnyCardController.selectedSuturesNames[id] ??
                        homePageController.sutures
                            .firstWhereOrNull((e) => e.id == id)
                            ?.name ??
                        id;

                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xffE5E7EB),
                          width: 1.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              itemName,
                              style: GoogleFonts.arimo(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Quantity Selector
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffF3F4F6),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildQtyButton(
                                  icon: Icons.remove,
                                  onPressed: () => updateQuantity(id, -1),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: Text(
                                    quantity.toString(),
                                    style: GoogleFonts.arimo(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xff9945FF),
                                    ),
                                  ),
                                ),
                                _buildQtyButton(
                                  icon: Icons.add,
                                  onPressed: () => updateQuantity(id, 1),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: () => removeItem(id),
                            child: Icon(
                              Icons.close_rounded,
                              size: 18.sp,
                              color: Colors.red.shade300,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Icon(icon, size: 16.sp, color: Colors.grey.shade600),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
