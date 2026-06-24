import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:tbsosick/presentation/controllers/bottom_nab_bar_controller.dart';
import 'package:tbsosick/presentation/controllers/homepage_controller.dart';
import 'package:tbsosick/presentation/screens/home/controller/prefrance_card_ditails_controller.dart';
import 'package:tbsosick/presentation/widgets/procedure_card.dart';
import 'package:tbsosick/l10n/app_localizations.dart';
import 'package:tbsosick/core/services/iap_service.dart';

class PreferenceCardFavorites extends StatefulWidget {
  const PreferenceCardFavorites({super.key});

  @override
  State<PreferenceCardFavorites> createState() =>
      _PreferenceCardFavoritesState();
}

class _PreferenceCardFavoritesState extends State<PreferenceCardFavorites> {
  final BottomNabBarController _bottomNabBarController =
      Get.find<BottomNabBarController>();
  final HomePageController _homePageController = Get.find<HomePageController>();
  final PrefranceCardDetailsController _prefranceCardDetailsController =
      Get.find<PrefranceCardDetailsController>();

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(tr),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _bottomNabBarController.getFavoriteCard();
              },
              color: const Color(0xFF6C36B2),
              child: Obx(() {
                if (_bottomNabBarController.isFavoriteCardsLoading.value &&
                    _bottomNabBarController.favoriteCards.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_bottomNabBarController.favoriteCards.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 400.h,
                      child: Center(child: Text(tr.noFavoriteItem)),
                    ),
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  itemCount: _bottomNabBarController.favoriteCards.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _bottomNabBarController.favoriteCards.length) {
                      return _buildLoadMoreButton();
                    }
                    final card = _bottomNabBarController.favoriteCards[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: ProcedureCard(
                        isPaidUser: Get.find<IapService>().isPremiumUser,
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
                            await _homePageController.removeFromFavoriteList(
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
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations tr) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 50.h,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF6C36B2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              tr.preferenceCardFavorites,
              style: GoogleFonts.arimo(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    if (!_bottomNabBarController.hasMoreFavorite.value) {
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
        child: _bottomNabBarController.isFavoriteMoreLoading.value
            ? const CircularProgressIndicator()
            : TextButton(
                onPressed: () {
                  _bottomNabBarController.loadMoreFavorite();
                },
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
