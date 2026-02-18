import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tbsosick/presentation/controllers/bottom_nab_bar_controller.dart';
import 'package:tbsosick/presentation/controllers/homepgeController.dart';
import 'package:tbsosick/presentation/screens/home/controller/prefrance_card_ditails_controller.dart';
import 'package:tbsosick/presentation/widgets/procedure_card.dart';

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
      final PrefranceCardDetailsController _prefranceCardDetailsController = Get.find<PrefranceCardDetailsController>(
      
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _bottomNabBarController.getFavoriteCard();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
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
                    Obx(() {
                      if (_bottomNabBarController.isLoading.value &&
                          _bottomNabBarController.favoriteCards.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (_bottomNabBarController.favoriteCards.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: const Center(
                            child: Text("No favorite cards"),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount:
                            _bottomNabBarController.favoriteCards.length + 1,
                        itemBuilder: (context, index) {
                          if (index ==
                              _bottomNabBarController.favoriteCards.length) {
                            return _buildLoadMoreButton();
                          }
                          final card =
                              _bottomNabBarController.favoriteCards[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: ProcedureCard(
                              onDownloadTap: () {
                                _prefranceCardDetailsController
                                    .downloadCard(cardId: card.id);
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
                                          cardId: card.id);
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
                  ],
                ),
              ),
            ],
          ),
        ),
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
