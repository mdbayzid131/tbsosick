import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/screens/home/preference_card_details.dart';

import 'home_screen.dart';

class PreferenceCardFavorites extends StatefulWidget {
  const PreferenceCardFavorites({super.key});

  @override
  State<PreferenceCardFavorites> createState() =>
      _PreferenceCardFavoritesState();
}

class _PreferenceCardFavoritesState extends State<PreferenceCardFavorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // fixed header
            Container(
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
              child: Text(
                'Favorites card',
                style: GoogleFonts.arimo(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  Text(
                    'Preference card favorites',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff1C1B1F),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  ListView.builder(
                    shrinkWrap: true,
                    // এটা important
                    physics: const NeverScrollableScrollPhysics(),
                    // এটা important - parent scroll করবে
                    padding: EdgeInsets.zero,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: InkWell(
                          onTap: () {
                            Get.to(PreferenceCardDetails(isPrivate: false));
                          },

                          child: favoriteCard(
                            title: 'Total Knee Replacement',
                            status: 'Completed',
                            statusColor: const Color(0xffE6F6EA),
                            statusTextColor: const Color(0xff2E9B4E),
                            date: '2026-01-02',
                            doctor: 'Dr. Sarah Johnson',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // scrollable body
          ],
        ),
      ),
    );
  }
}
