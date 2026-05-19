import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/presentation/controllers/homepgeController.dart';
import 'package:tbsosick/presentation/screens/home/controller/prefrance_card_ditails_controller.dart';
import 'package:tbsosick/presentation/widgets/procedure_card.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/presentation/binding/bottom_nab_bar_binding.dart';
import 'package:tbsosick/presentation/controllers/bottom_nab_bar_controller.dart';
import 'package:tbsosick/presentation/screens/home/Preference%20card/new_preference_card.dart';
import 'package:tbsosick/presentation/screens/home/preference_card_favorites.dart';

import 'package:tbsosick/core/services/iap_service.dart';
import 'notification_bottom.dart';
import 'package:tbsosick/presentation/controllers/notification_controller.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BottomNabBarController _bottomNabBarController = Get.put(
    BottomNabBarController(),
  );
  final HomePageController _homePageController = Get.put(HomePageController());

  String _greetingForNow(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final hour = now.hour;
    if (hour >= 5 && hour < 12) return tr.goodMorning;
    if (hour >= 12 && hour < 17) return tr.goodAfternoon;
    if (hour >= 17 && hour < 22) return tr.goodEvening;
    return tr.goodNight;
  }

  final PrefranceCardDetailsController _prefranceCardDetailsController =
      Get.find<PrefranceCardDetailsController>();

  @override
  Widget build(BuildContext context) {
    // Status bar icons white করার জন্য
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor:
            Colors.transparent, // transparent রাখব, overlay দিয়ে handle করব
        statusBarIconBrightness: Brightness.light, // Android: white icons
        statusBarBrightness: Brightness.dark, // iOS: white icons
      ),
    );

    final statusBarHeight = MediaQuery.of(context).padding.top;
    final tr = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () async {
        final result = await Connectivity().checkConnectivity();
        if (result.contains(ConnectivityResult.none)) {
          Helpers.showError('No internet connection');
          return;
        }
        await _bottomNabBarController.loadHomeData();
      },
      child: Stack(
        children: [
          // ── Main scrollable content ──
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _headerSection(context),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          tr.quickActions,
                          style: GoogleFonts.arimo(
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
                              title: tr.createPreferenceCard,
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
                              title: tr.createPrivateCard,
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
                      Row(
                        children: [
                          Text(
                            tr.preferenceCardFavorites,
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
                      Obx(() {
                        if (_bottomNabBarController
                            .isFavoriteCardsLoading
                            .value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (_bottomNabBarController.favoriteCards.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Center(
                              child: Text(
                                tr.noFavoriteItem,
                                style: GoogleFonts.arimo(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }
                        final cardsToShow = _bottomNabBarController
                            .favoriteCards
                            .take(10)
                            .toList();
                        return Column(
                          children: cardsToShow.map((card) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: ProcedureCard(
                                isPaidUser:
                                    Get.find<IapService>().isPremiumUser,
                                onDownloadTap: () {
                                  _prefranceCardDetailsController.downloadCard(
                                    cardId: card.id,
                                  );
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
                                        .removeFromFavoriteList(
                                          cardId: card.id,
                                        );
                                  } else {
                                    await _homePageController.addToFavoriteList(
                                      cardId: card.id,
                                    );
                                  }
                                  await _bottomNabBarController.getFavoriteCard(
                                    showLoading: false,
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        );
                      }),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Status bar gradient overlay ──
          // scroll করলে যাই দেখা যাক, status bar area সবসময় পরিষ্কার থাকবে
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: statusBarHeight, // status bar height + একটু extra
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF6C36B2)),
            ),
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
          mainAxisSize: MainAxisSize.min,
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerSection(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
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
                    color: Color(0xFF6C36B2),
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
                                  _greetingForNow(context),
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
                          Obx(() {
                            final notificationController =
                                Get.find<NotificationController>();
                            final count =
                                notificationController.unreadCount.value;
                            return Stack(
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
                                if (count > 0)
                                  Positioned(
                                    right: 2.w,
                                    top: 2.h,
                                    child: Container(
                                      padding: EdgeInsets.all(2.w),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 14.w,
                                        minHeight: 14.w,
                                      ),
                                      child: Center(
                                        child: Text(
                                          count > 9 ? '9+' : count.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
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
                                controller: _bottomNabBarController
                                    .globalSearchController,
                                onChanged: (value) {
                                  _bottomNabBarController
                                          .searchController
                                          .value =
                                      value;
                                },
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                  _bottomNabBarController.changePage(1);
                                },
                                style: GoogleFonts.arimo(
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: tr.searchProceduresCards,
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
                            Obx(() {
                              if (_bottomNabBarController
                                  .searchController
                                  .value
                                  .isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return GestureDetector(
                                onTap: () {
                                  _bottomNabBarController.changePage(1);
                                },
                                child: Icon(
                                  Icons.arrow_forward_outlined,
                                  size: 20.sp,
                                  color: const Color(0xff9AA1AF),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
                SizedBox(height: 100.w),
              ],
            ),
            Positioned(
              bottom: 10.w,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: _statCard(
                            onTap: () {
                              _bottomNabBarController.changePage(1);
                            },
                            icon: Icons.description_outlined,
                            count:
                                "${_bottomNabBarController.cardCount.value?.allCardsCount ?? 00}",
                            label: tr.allCard,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Container(
                          child: _statCard(
                            onTap: () {
                              Get.toNamed(AppRoutes.MY_CARDS);
                            },
                            icon: Icons.person_outline,
                            count:
                                "${_bottomNabBarController.cardCount.value?.myCardsCount ?? 00}",
                            label: tr.myCards,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard({
    required VoidCallback onTap,
    required IconData icon,
    required String count,
    required String label,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
