import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [_collapsingHeader(), _pageBody()]),
    );
  }
}

SliverAppBar _collapsingHeader() {
  return SliverAppBar(
    pinned: true,
    expandedHeight: 180.h,
    backgroundColor: const Color(0xff8A3AEA),
    flexibleSpace: FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      titlePadding: EdgeInsets.only(left: 20.w, bottom: 12.h),
      title: Text(
        'Dr. Anderson',
        style: GoogleFonts.arimo(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      background: Container(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 50.h),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff5B2C83), Color(0xff8A3AEA)],
          ),
        ),
        child: Text(
          'Good morning,',
          style: GoogleFonts.arimo(fontSize: 14.sp, color: Colors.white70),
        ),
      ),
    ),
  );
}

SliverToBoxAdapter _pageBody() {
  return SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: List.generate(
          15,
          (index) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    ),
  );
}
