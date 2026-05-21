import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/presentation/screens/home/controller/prefrance_card_ditails_controller.dart';
import 'package:tbsosick/l10n/app_localizations.dart';

import 'package:tbsosick/core/services/iap_service.dart';
import 'package:tbsosick/presentation/widgets/procedure_card.dart';
import 'package:tbsosick/presentation/controllers/bottom_nab_bar_controller.dart';
import 'package:tbsosick/presentation/controllers/homepage_controller.dart';
import 'package:tbsosick/presentation/widgets/custom_elevated_button.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // Filter states
  String _selectedSpecialty = 'All';
  bool _verifiedOnly = false;

  // Show filter bottom sheet
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  final controller = Get.find<BottomNabBarController>();
  final homePageController = Get.find<HomePageController>();
  final PrefranceCardDetailsController _prefranceCardDetailsController =
      Get.find<PrefranceCardDetailsController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.getLibraryCards(showLoading: false);
          },
          child: Column(
            children: [
              _buildHeader(),
              // SizedBox(height: 30.h),
              SizedBox(height: 12.h),
              Expanded(child: _buildLibraryCardsList()),
            ],
          ),
        ),
      ),
    );
  }

  // Header with gradient background and search bar
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 50.h,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF6C36B2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            AppLocalizations.of(context)!.preferenceLibraryTitle,
            style: GoogleFonts.arimo(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          // Search bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: TextField(
              controller: controller.globalSearchController,
              onChanged: (value) {
                controller.searchController.value = value;
              },
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                FocusScope.of(context).unfocus();
              },
              style: GoogleFonts.arimo(
                fontSize: 15.sp,
                color: const Color(0xFF79747E),
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchProceduresCards,
                hintStyle: GoogleFonts.arimo(
                  fontSize: 15.sp,
                  color: const Color(0xFF79747E),
                ),
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: const Color(0xFF8B5CF6),
                  size: 22.sp,
                ),
                suffixIcon: GestureDetector(
                  onTap: _showFilterBottomSheet,
                  child: Icon(
                    Icons.tune_outlined,
                    color: const Color(0xFF8B5CF6),
                    size: 22.sp,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Unified Library Cards List
  Widget _buildLibraryCardsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card count
          Obx(() {
            if (controller.isLibrarySubscriptionInactive.value) {
              return const SizedBox.shrink();
            }
            return Text(
              '${controller.libraryCards.length} Cards',
              style: GoogleFonts.arimo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
            );
          }),
          Obx(() => controller.isLibrarySubscriptionInactive.value
              ? const SizedBox.shrink()
              : SizedBox(height: 12.h)),
          // Cards list
          Expanded(
            child: Obx(() {
              if (controller.isLibraryCardsLoading.value &&
                  controller.libraryCards.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.isLibrarySubscriptionInactive.value) {
                return _buildSubscriptionRequiredUI();
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }
              if (controller.libraryCards.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noCardsFound),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.libraryCards.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.libraryCards.length) {
                    return _buildLoadMoreButton(
                      isLoading: controller.isLibraryMoreLoading.value,
                      hasMore: controller.hasMoreLibrary.value,
                      onPressed: () => controller.loadMoreLibraryCards(),
                    );
                  }
                  final card = controller.libraryCards[index];
                  return Column(
                    children: [
                      ProcedureCard(
                        isPaidUser: Get.find<IapService>().isPremiumUser,
                        onDownloadTap: () => _prefranceCardDetailsController
                            .downloadCard(cardId: card.id),
                        cardId: card.id,
                        title: card.cardTitle,
                        specialty: card.surgeonSpecialty,
                        isVerified: card.verificationStatus == 'VERIFIED',
                        doctor:
                            "${AppLocalizations.of(context)!.by} ${card.surgeonName}",
                        downloads: card.downloadCount,
                        updatedTime: card.updatedAt,
                        isFavorite: card.isFavorited,
                        isPrivateCard: false,
                        onFavoriteToggle: () async {
                          if (card.isFavorited) {
                            await homePageController.removeFromFavoriteList(
                              cardId: card.id,
                            );
                          } else {
                            await homePageController.addToFavoriteList(
                              cardId: card.id,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 12.h),
                    ],
                  );
                },
              );
            }),
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
            AppLocalizations.of(context)!.noMoreData,
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
                  AppLocalizations.of(context)!.loadMore,
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

  // Filter bottom sheet
  Widget _buildFilterBottomSheet() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Title
                  Text(
                    AppLocalizations.of(context)!.filters,
                    style: GoogleFonts.arimo(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1C1B1F),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Specialty section
                  Text(
                    AppLocalizations.of(context)!.specialty.toUpperCase(),
                    style: GoogleFonts.arimo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9CA3AF),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Specialty chips
                  Obx(
                    () => Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _buildFilterChip(
                          AppLocalizations.of(context)!.all,
                          _selectedSpecialty == 'All',
                          () {
                            setModalState(() {
                              _selectedSpecialty = 'All';
                            });
                          },
                        ),
                        ...controller.specialtiesList.map(
                          (specialty) => _buildFilterChip(
                            specialty.name,
                            _selectedSpecialty == specialty.name,
                            () {
                              setModalState(() {
                                _selectedSpecialty = specialty.name;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Verified Only toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.verifiedOnly,
                        style: GoogleFonts.arimo(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1C1B1F),
                        ),
                      ),
                      Switch(
                        value: _verifiedOnly,
                        onChanged: (value) {
                          setModalState(() {
                            _verifiedOnly = value;
                          });
                        },
                        activeThumbColor: const Color(0xFF8B5CF6),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  // Apply Filters button
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: CustomElevatedButton(
                      onPressed: () {
                        controller.specialtyFilter.value = _selectedSpecialty;
                        controller.verifiedOnlyFilter.value = _verifiedOnly;
                        controller.getLibraryCards();
                        Navigator.pop(context);
                      },
                      label: AppLocalizations.of(context)!.applyFilters,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // UI shown when subscription is required
  Widget _buildSubscriptionRequiredUI() {
    final tr = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 60.sp,
                color: const Color(0xFF8B5CF6),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Subscription Required',
              style: GoogleFonts.arimo(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1C1B1F),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Your subscription is inactive. Please subscribe to access the full Preference Library.',
              style: GoogleFonts.arimo(
                fontSize: 15.sp,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: CustomElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.subscription),
                label: tr.choosePlanTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter chip widget
  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.arimo(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF1C1B1F),
          ),
        ),
      ),
    );
  }
}
