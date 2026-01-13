import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notification_bottom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // fixed header
        heder_section(),

        // scrollable body
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Quick Actions',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff1C1B1F),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      Expanded(
                        child: _quickActionCard(
                          title: 'Create Preference card',
                          onTap: () {},
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _quickActionCard(
                          title: 'Create Private Card',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Text(
                        'Preference card favorites',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff1C1B1F),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Text(
                              'View All',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff6750A4),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14.sp,
                              color: const Color(0xff6750A4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // list items
                  ...List.generate(
                    3,
                        (index) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _favoriteCard(
                        title: 'Total Knee Replacement',
                        status: 'Completed',
                        statusColor: const Color(0xffE6F6EA),
                        statusTextColor: const Color(0xff2E9B4E),
                        date: '2026-01-02',
                        doctor: 'Dr. Sarah Johnson',
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _favoriteCard({
    required String title,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String date,
    required String doctor,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xffE7E0EC), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff1C1B1F),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: statusTextColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 14.sp,
                color: const Color(0xff79747E),
              ),
              SizedBox(width: 4.w),
              Text(
                date,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  color: const Color(0xff79747E),
                ),
              ),
              SizedBox(width: 14.w),
              Icon(
                Icons.person_outline_outlined,
                size: 14.sp,
                color: const Color(0xff79747E),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  doctor,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: const Color(0xff79747E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionCard({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff6950A7), Color(0xfF9746FB)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.description_outlined,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column heder_section() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: 272.h,
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 50.h,
                bottom: 32.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.r),
                  bottomRight: Radius.circular(32.r),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xff9945FF), Color(0xff271E3E)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good morning,',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: Color(0xffE8DEF8),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Dr. Anderson',
                              style: GoogleFonts.roboto(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){showNotificationBottomSheet(context);},
                            child: Container(
                              height: 40.w,
                              width: 40.w,
                              decoration: BoxDecoration(
                                color: Color(0xff7965AF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    height: 46.h,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F7),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_outlined,
                          size: 22.sp,
                          color: Color(0xff9AA1AF),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search procedures, cards...',
                              hintStyle: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                color: const Color(0xff79747E),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -90,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        icon: Icons.description_outlined,
                        count: '6',
                        label: 'All Card',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _statCard(
                        icon: Icons.person_outline,
                        count: '0',
                        label: 'My Cards',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}

Widget _statCard({
  required IconData icon,
  required String count,
  required String label,
}) {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: const Color(0xffE7E0EC), width: 1.w),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40.w,
          width: 40.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: const Color(0xffE8DEF8),
          ),
          child: Icon(icon, size: 20.sp, color: const Color(0xff6750A4)),
        ),
        SizedBox(height: 14.h),
        Text(
          count,
          style: GoogleFonts.roboto(
            fontSize: 24.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff1C1B1F),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            color: const Color(0xff79747E),
          ),
        ),
      ],
    ),
  );
}
