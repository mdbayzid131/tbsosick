import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/l10n/app_localizations.dart';
import 'package:tbsosick/presentation/screens/home/controller/prefrance_card_ditails_controller.dart';
import 'package:tbsosick/presentation/widgets/my_procedure_card.dart';
import 'package:tbsosick/presentation/widgets/procedure_card.dart';
import 'package:tbsosick/presentation/controllers/homepgeController.dart';
import 'package:tbsosick/presentation/screens/my%20cards/controller/my_cards_controller.dart';

class MyCardsScreen extends StatefulWidget {
  const MyCardsScreen({super.key});

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final MyCardsController controller = Get.find<MyCardsController>();
  final homePageController = Get.find<HomePageController>();
  final PrefranceCardDetailsController _prefranceCardDetailsController =
      Get.find<PrefranceCardDetailsController>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            await controller.refreshCards();
          },
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 12.h),

              // Tabs for Public and Private
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: _buildTab(
                          title: 'Public',
                          isSelected:
                              controller.selectedVisibility.value == 'public',
                          onTap: () => controller.changeVisibility('public'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildTab(
                          title: 'Private',
                          isSelected:
                              controller.selectedVisibility.value == 'private',
                          onTap: () => controller.changeVisibility('private'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              Expanded(child: _buildLibraryCardsList()),
            ],
          ),
        ),
      ),
    );
  }

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
        color: const Color(0xFF6C36B2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Cards',
            style: GoogleFonts.arimo(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                controller.searchController.value = value;
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

  Widget _buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6C36B2)
              : const Color.fromARGB(255, 223, 224, 226),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.arimo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryCardsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              '${controller.myCards.length} Cards',
              style: GoogleFonts.arimo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Added divider
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.myCards.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }
              if (controller.myCards.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noCardsFound),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.myCards.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.myCards.length) {
                    return _buildLoadMoreButton(
                      isLoading: controller.isMoreLoading.value,
                      hasMore: controller.hasMoreCards.value,
                      onPressed: () => controller.loadMoreCards(),
                    );
                  }
                  final card = controller.myCards[index];
                  return Column(
                    children: [
                      MyProcedureCard(
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
                        isPrivateCard:
                            controller.selectedVisibility.value == 'private',
                        onEditTap: () {
                          // TODO: Navigate to edit screen
                          Helpers.showSuccess('Edit screen coming soon');
                        },
                        onDeleteTap: () {
                          _showDeleteConfirmation(context, card.id);
                        },
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

  void _showDeleteConfirmation(BuildContext context, String cardId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Card'),
        content: const Text('Are you sure you want to delete this card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteCard(cardId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
