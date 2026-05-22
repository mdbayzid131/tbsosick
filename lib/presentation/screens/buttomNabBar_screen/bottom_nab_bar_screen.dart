import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:tbsosick/config/themes/app_theme.dart';
import 'package:tbsosick/presentation/binding/bottom_nab_bar_binding.dart';

import '../../../config/constants/image_paths.dart';
import '../../controllers/bottom_nab_bar_controller.dart';
import '../ProfilePage/profile_page.dart';
import '../calendar_page/calendar_page.dart';
import '../home/Preference card/new_preference_card.dart';
import '../home/home_screen.dart';
import '../library/library_screen.dart';
import 'package:tbsosick/core/widgets/safe_network_image.dart';

class BottomNabBarScreen extends StatelessWidget {
  BottomNabBarScreen({super.key});

  final nav = Get.find<BottomNabBarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBody: true,
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: nav.currentIndex.value,
            children: const [
              HomeScreen(),
              LibraryScreen(),
              CalendarPage(),
              ProfilePage(),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          bottom: true,
          child: CustomBottomBar(),
        ),
      ),
    );
  }
}

class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({super.key});

  final nav = Get.find<BottomNabBarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 80.h,
        decoration: const BoxDecoration(color: Color(0xffF2F2F7)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _icon(ImagePaths.homeIcon, 0),
                _icon(ImagePaths.libraryIcon, 1),
                SizedBox(width: 70.w),
                _icon(ImagePaths.calenderIcon, 2),
                ppIcon(3),
              ],
            ),

            Positioned(
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    NewPreferenceCard(isPrivate: false),
                    binding: PostAnyCardBinding(),
                    transition: Transition.downToUp,
                  );
                },
                child: _centerButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _icon(String svgPath, int index) {
    return InkWell(
      onTap: () => nav.changePage(index),
      child: SizedBox(
        height: 26.w,
        width: 26.w,
        child: SvgPicture.asset(
          svgPath,
          width: 26.w,
          height: 26.w,
          colorFilter: ColorFilter.mode(
            nav.currentIndex.value == index
                ? AppTheme.primaryColor
                : const Color(0xff99A1AF),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget ppIcon(int index) {
    return GestureDetector(
      onTap: () => nav.changePage(index),
      child: Container(
        width: 35.w,
        height: 35.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: nav.currentIndex.value == index
                ? AppTheme.primaryColor
                : Colors.grey,
            width: 2.w,
          ),
        ),
        padding: EdgeInsets.all(0.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: Builder(
            builder: (context) {
              final profileUrl = nav.user.value?.profilePicture;
              final fallback = Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF8E3DF6),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
              );

              if (profileUrl != null && profileUrl.isNotEmpty) {
                return SafeNetworkImage(
                  imageUrl: profileUrl,
                  width: 35.w,
                  height: 35.w,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(100.r),
                  errorWidget: fallback,
                );
              } else {
                return fallback;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _centerButton() {
    return Container(
      height: 64.w,
      width: 64.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff9945FF), Color(0xff8B3EFF), Color(0xff7B35DD)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff9945FF),
            offset: Offset(0, 8),
            blurRadius: 10,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Center(
        child: Icon(Icons.add_outlined, color: Colors.white, size: 35.sp),
      ),
    );
  }
}
