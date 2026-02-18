import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/presentation/controllers/homepgeController.dart';
import 'package:tbsosick/presentation/screens/home/controller/prefrance_card_ditails_controller.dart';
import 'package:tbsosick/presentation/widgets/procedure_card.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/presentation/binding/bottom_nab_bar_binding.dart';
import 'package:tbsosick/presentation/controllers/bottom_nab_bar_controller.dart';
import 'package:tbsosick/presentation/screens/home/Preference%20card/new_preference_card.dart';
import 'package:tbsosick/presentation/screens/home/preference_card_favorites.dart';

import 'notification_bottom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BottomNabBarController _bottomNabBarController = Get.put(
    BottomNabBarController(),
  );
  final HomePageController _homePageController = Get.put(
    HomePageController(),
  );

  String _greetingForNow() {
    final now = DateTime.now();
    final hour = now.hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning,';
    }
    if (hour >= 12 && hour < 17) {
      return 'Good afternoon,';
    }
    if (hour >= 17 && hour < 22) {
      return 'Good evening,';
    }
    return 'Good night,';
  }
 final PrefranceCardDetailsController _prefranceCardDetailsController = Get.find<PrefranceCardDetailsController>(
 
  );
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final result = await Connectivity().checkConnectivity();

        // ignore: unrelated_type_equality_checks
        if (result == ConnectivityResult.none) {
          Helpers.showCustomSnackBar('No internet connection', isError: true);
          return;
        }

        await _bottomNabBarController.loadHomeData();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Fixed header
            _headerSection(),

            // Scrollable body
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // Quick Actions title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Quick Actions',
                      style: GoogleFonts.arimo(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff1C1B1F),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Quick action cards row
                  Row(
                    children: [
                      Expanded(
                        child: _quickActionCard(
                          title: 'Create Preference card',
                          onTap: () {
                            Get.to(
                              NewPreferenceCard(isPrivate: false),
                              binding: PostAnyCardBinding(),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _quickActionCard(
                          title: 'Create Private Card',
                          onTap: () {
                            Get.to(
                              NewPreferenceCard(isPrivate: true),
                              binding: PostAnyCardBinding(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Preference card favorites header
                  Row(
                    children: [
                      Text(
                        'Preference card favorites',
                        style: GoogleFonts.arimo(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff1C1B1F),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const PreferenceCardFavorites());
                        },
                        child: Row(
                          children: [
                            Text(
                              'View All',
                              style: GoogleFonts.arimo(
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

                  SizedBox(height: 12.h),

                  // List items
                  Obx(() {
                    if (_bottomNabBarController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_bottomNabBarController.favoriteCards.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: const Center(child: Text("No cards found")),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _bottomNabBarController.favoriteCards.length + 1,
                      itemBuilder: (context, index) {
                        if (index ==
                            _bottomNabBarController.favoriteCards.length) {
                          return _buildLoadMoreButton(
                            isLoading: _bottomNabBarController
                                .isFavoriteMoreLoading
                                .value,
                            hasMore:
                                _bottomNabBarController.hasMoreFavorite.value,
                            onPressed: () =>
                                _bottomNabBarController.loadMoreFavorite(),
                          );
                        }
                        final card = _bottomNabBarController.favoriteCards[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: ProcedureCard(
                            onDownloadTap: () {
                              _prefranceCardDetailsController.downloadCard(cardId: card.id);
                            },
                            isPrivateCard: false,
                            cardId: card.id,
                            title: card.cardTitle,
                            specialty: card.surgeonSpecialty,
                            isVerified: card.isVerified,
                            doctor: card.surgeonName,
                            downloads: card.totalDownloads,
                            updatedTime: card.updatedAt,
                            isFavorite: card.isFavorite,
                            onFavoriteToggle: () async {
                              if (card.isFavorite) {
                                await _homePageController
                                    .removeFromFavoriteList(cardId: card.id);
                              } else {
                                await _homePageController
                                    .addToFavoriteList(cardId: card.id);
                              }
                              await _bottomNabBarController
                                  .getFavoriteCard(showLoading: false);
                            },
                          ),
                        );
                      },
                    );
                  }),

                  SizedBox(height: 90.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quick action card widget
  Widget _quickActionCard({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
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
              blurRadius: 12.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ← এটা খুব জরুরি
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
              style: GoogleFonts.arimo(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              // যদি title অনেক লম্বা হয় তাহলে এগুলো যোগ করতে পারো:
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Header section with gradient
  Widget _headerSection() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 50.h,
                bottom: 32.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
                gradient: const LinearGradient(
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
                              _greetingForNow(),
                              style: GoogleFonts.arimo(
                                fontSize: 16.sp,
                                color: const Color(0xffE8DEF8),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Obx(
                              () => Text(
                                _bottomNabBarController.user.value?.name ??
                                    'Loading...',
                                style: GoogleFonts.arimo(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              showNotificationBottomSheet(context);
                            },
                            child: Container(
                              height: 40.w,
                              width: 40.w,
                              decoration: const BoxDecoration(
                                color: Color(0xff7965AF),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 6.w,
                            top: 6.h,
                            child: Container(
                              height: 8.w,
                              width: 8.w,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F7),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_outlined,
                          size: 22.sp,
                          color: const Color(0xff9AA1AF),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                              text: _bottomNabBarController
                                  .searchController
                                  .value,
                            ),
                            onChanged: (value) {
                              _bottomNabBarController.searchController.value =
                                  value;
                            },
                            style: GoogleFonts.arimo(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search procedures, cards...',
                              hintStyle: GoogleFonts.arimo(
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
                  SizedBox(height: 80.h),
                ],
              ),
            ),
            Positioned(
              bottom: -90.w,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: Icons.description_outlined,
                          count:
                              "${_bottomNabBarController.cardCount.value?.allCardsCount ?? 00}",
                          label: 'All Card',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _statCard(
                          icon: Icons.person_outline,
                          count:
                              "${_bottomNabBarController.cardCount.value?.myCardsCount ?? 00}",
                          label: 'My Cards',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 100.w),
      ],
    );
  }

  // Stat card widget
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
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
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
            style: GoogleFonts.arimo(
              fontSize: 24.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff1C1B1F),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              color: const Color(0xff79747E),
            ),
          ),
        ],
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
}
