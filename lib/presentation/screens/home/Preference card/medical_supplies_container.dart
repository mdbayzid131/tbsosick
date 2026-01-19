import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../dummy_data.dart';

class MedicalSuppliesScreen extends StatefulWidget {
  const MedicalSuppliesScreen({super.key});

  @override
  State<MedicalSuppliesScreen> createState() => _MedicalSuppliesScreenState();
}

class _MedicalSuppliesScreenState extends State<MedicalSuppliesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<String> selectedItems = [
  ];



  List<String> get filteredSupplies {
    if (_searchController.text.isEmpty) return [];
    return allSupplies
        .where(
          (item) =>
              item.toLowerCase().contains(_searchController.text.toLowerCase()),
        )
        .toList();
  }

  void removeItem(String item) {
    setState(() {
      selectedItems.remove(item);
    });
  }

  void addItem(String item) {
    if (!selectedItems.contains(item)) {
      setState(() {
        selectedItems.add(item);
      });
    }
  }

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
                border: Border.all(
                  color: _searchFocusNode.hasFocus
                      ? const Color(0xff9945FF)
                      : Colors.grey.shade300,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: _searchFocusNode.hasFocus
                    ? [
                        BoxShadow(
                          color: const Color(0xff9945FF).withOpacity(0.1),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ]
                    : [],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search thousands of supplies...',
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
              ),
            ),

            // Search Results Dropdown
            if (_searchController.text.isNotEmpty &&
                filteredSupplies.isNotEmpty) ...[
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
                  itemCount: filteredSupplies.length,
                  itemBuilder: (context, index) {
                    final item = filteredSupplies[index];
                    final isSelected = selectedItems.contains(item);
                    return InkWell(
                      onTap: () {
                        if (isSelected) {
                          removeItem(item);
                        } else {
                          addItem(item);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xff9945FF).withOpacity(0.05)
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item,
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
                              isSelected ? Icons.check_circle : Icons.add,
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

            // No Results
            if (_searchController.text.isNotEmpty &&
                filteredSupplies.isEmpty) ...[
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 2.w),
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
                        'Selected Items (${selectedItems.length})',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff9945FF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  if (selectedItems.isEmpty)
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
                      children: selectedItems.map((item) {
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
                              Text(
                                item,
                                style: TextStyle(
                                  color: const Color(0xff9945FF),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 8.w),
                              InkWell(
                                onTap: () => removeItem(item),
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
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
