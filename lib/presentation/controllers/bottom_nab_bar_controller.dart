import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/services/iap_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/utils/subscription_helper.dart';
import 'package:tbsosick/data/models/card_count_model.dart';
import 'package:tbsosick/data/models/favorite_card_model.dart';
import 'package:tbsosick/data/models/private_card_model.dart';
import 'package:tbsosick/data/models/library_card_model.dart';
import 'package:tbsosick/data/models/user_model.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';
import 'package:tbsosick/data/models/specialty_model.dart';

class BottomNabBarController extends GetxController {
  final UserDataRepository _userDataRepository = UserDataRepository();

  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  // data list
  // final RxList<PublicCard> publicCards = <PublicCard>[].obs;
  // card list
  final RxList<PrivateCard> privateCards = <PrivateCard>[].obs;
  // library cards (unified list)
  final RxList<LibraryCard> libraryCards = <LibraryCard>[].obs;
  // favorite cards
  final RxList<FavoriteCard> favoriteCards = <FavoriteCard>[].obs;
  // specialties
  final RxList<Specialty> specialtiesList = <Specialty>[].obs;
  // user data
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  // card count
  final Rx<CardCountModel?> cardCount = Rx<CardCountModel?>(null);

  // error message (optional)
  final RxString errorMessage = ''.obs;

  // loading states
  final RxBool isProfileLoading = false.obs;
  final RxBool isCardCountLoading = false.obs;
  final RxBool isPublicCardsLoading = false.obs;
  final RxBool isPrivateCardsLoading = false.obs;
  final RxBool isFavoriteCardsLoading = false.obs;
  final RxBool isLibraryCardsLoading = false.obs;
  final RxBool isSpecialtiesLoading = false.obs;
  final RxBool isPublicMoreLoading = false.obs;
  final RxBool isPrivateMoreLoading = false.obs;
  final RxBool isFavoriteMoreLoading = false.obs;
  final RxBool isLibraryMoreLoading = false.obs;
  final RxBool isLibrarySubscriptionInactive = false.obs;

  // pagination
  int _favoritePage = 1;
  int _libraryPage = 1;
  final RxBool hasMoreFavorite = true.obs;
  final RxBool hasMorePublic = true.obs;
  final RxBool hasMorePrivate = true.obs;
  final RxBool hasMoreLibrary = true.obs;

  // Search
  final TextEditingController globalSearchController = TextEditingController();
  final RxString searchController = ''.obs;

  // Filters
  final RxString specialtyFilter = 'All'.obs;
  final RxBool verifiedOnlyFilter = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Replaced addListener with direct onChanged binding in the UI to prevent double firing

    loadHomeData();
    debounce(searchController, (_) {
      getLibraryCards(showLoading: true);
    }, time: const Duration(milliseconds: 500));
  }

  Future<void> loadHomeData() async {
    try {
      await Future.wait([
        getProfile(showLoading: false),
        getAllCardCount(showLoading: false),
        getFavoriteCard(showLoading: false),
        getLibraryCards(showLoading: false),
        getSpecialtiesList(showLoading: false),
      ]);
    } catch (e) {
      Helpers.showError(e.toString());
    }
  }

  Future<void> getSpecialtiesList({bool showLoading = true}) async {
    try {
      if (showLoading) isSpecialtiesLoading.value = true;
      final response = await _userDataRepository.getSpecialties();
      if (response.data != null && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        specialtiesList.value = data.map((e) => Specialty.fromJson(e)).toList();
      }
    } catch (e) {
      Helpers.error("Error fetching specialties: $e");
    } finally {
      if (showLoading) isSpecialtiesLoading.value = false;
    }
  }

  /// 🔥 GET LIBRARY CARDS (Unified List)
  Future<void> getLibraryCards({bool showLoading = true}) async {
    try {
      if (showLoading) isLibraryCardsLoading.value = true;
      isLibrarySubscriptionInactive.value = false;
      _libraryPage = 1;

      final response = await _userDataRepository.getLibraryCards(
        page: _libraryPage,
        search: searchController.value,
        specialty: specialtyFilter.value == 'All' ? '' : specialtyFilter.value,
        verificationStatus: verifiedOnlyFilter.value ? 'VERIFIED' : '',
      );

      if (response.statusCode == 402) {
        isLibrarySubscriptionInactive.value = true;
        return;
      }

      ApiChecker.checkGetApi(response);
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
                ? response.data['data']
                : response.data;

        final result = LibraryCardsResponse.fromJson(data);
        libraryCards.assignAll(result.data);
        hasMoreLibrary.value = _libraryPage < result.meta.totalPages;
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 402) {
        isLibrarySubscriptionInactive.value = true;
      } else {
        Helpers.error("Error loading library cards: $e");
      }
    } finally {
      if (showLoading) isLibraryCardsLoading.value = false;
    }
  }

  Future<void> loadMoreLibraryCards() async {
    if (!hasMoreLibrary.value || isLibraryMoreLoading.value) return;

    try {
      isLibraryMoreLoading.value = true;
      _libraryPage++;

      final response = await _userDataRepository.getLibraryCards(
        page: _libraryPage,
        search: searchController.value,
        specialty: specialtyFilter.value == 'All' ? '' : specialtyFilter.value,
        verificationStatus: verifiedOnlyFilter.value ? 'VERIFIED' : '',
      );

      if (response.statusCode == 402) {
        isLibrarySubscriptionInactive.value = true;
        return;
      }

      ApiChecker.checkGetApi(response);
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
            ? response.data['data']
            : response.data;
        final result = LibraryCardsResponse.fromJson(data);
        libraryCards.addAll(result.data);
        hasMoreLibrary.value = _libraryPage < result.meta.totalPages;
      }
    } catch (e) {
      _libraryPage--; // rollback
      Helpers.error("Error loading more library cards: $e");
    } finally {
      isLibraryMoreLoading.value = false;
    }
  }

  ///================================================

  Future<void> getProfile({bool showLoading = true}) async {
    try {
      if (showLoading) isProfileLoading.value = true;
      errorMessage.value = '';
      final response = await _userDataRepository.getProfile();
      ApiChecker.checkGetApi(response);

      if (response.statusCode == 200 && response.data != null) {
        user.value = UserModel.fromJson(response.data['data']);
      }
    } catch (e) {
      Helpers.error("Error loading profile: $e");
    } finally {
      if (showLoading) isProfileLoading.value = false;
    }
  }

  ///================================================
  Future<void> getAllCardCount({bool showLoading = true}) async {
    try {
      if (showLoading) isCardCountLoading.value = true;
      errorMessage.value = '';
      final response = await _userDataRepository.getCardCount();
      ApiChecker.checkGetApi(response);

      cardCount.value = CardCountModel.fromJson(response.data['data']);
    } catch (e) {
      Helpers.error("Error loading card count: $e");
    } finally {
      if (showLoading) isCardCountLoading.value = false;
    }
  }

  /// 🔥 GET FAVORITE CARDS
  Future<void> getFavoriteCard({bool showLoading = true}) async {
    try {
      if (showLoading) isFavoriteCardsLoading.value = true;
      _favoritePage = 1;
      errorMessage.value = '';

      final response = await _userDataRepository.getFavoriteCard(
        page: _favoritePage,
        // search: searchController.value,
        // specialty:
        //     specialtyFilter.value == 'All' ? '' : specialtyFilter.value,
        // verificationStatus:
        //     verifiedOnlyFilter.value ? 'VERIFIED' : '',
      );
      ApiChecker.checkGetApi(response);
      if (response.statusCode == 200 && response.data != null) {
        // API response might be nested under 'data' or flat
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
            ? response.data['data']
            : response.data;

        final result = FavoriteCardsResponse.fromJson(data);

        favoriteCards.assignAll(result.data);
        hasMoreFavorite.value = _favoritePage < result.pagination.totalPage;
      }
    } catch (e) {
      Helpers.error("Error loading favorite cards: $e");
    } finally {
      if (showLoading) isFavoriteCardsLoading.value = false;
    }
  }

  Future<void> loadMoreFavorite() async {
    if (!hasMoreFavorite.value || isFavoriteMoreLoading.value) return;

    try {
      isFavoriteMoreLoading.value = true;
      _favoritePage++;

      final response = await _userDataRepository.getFavoriteCard(
        page: _favoritePage,
        // search: searchController.value,
        // specialty:
        //     specialtyFilter.value == 'All' ? '' : specialtyFilter.value,
        // verificationStatus:
        //     verifiedOnlyFilter.value ? 'VERIFIED' : '',
      );
      ApiChecker.checkGetApi(response);

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
            ? response.data['data']
            : response.data;
        final result = FavoriteCardsResponse.fromJson(data);
        favoriteCards.addAll(result.data);
        hasMoreFavorite.value = _favoritePage < result.pagination.totalPage;
      }
    } catch (e) {
      _favoritePage--; // rollback
      Helpers.error("Error loading more favorite cards: $e");
    } finally {
      isFavoriteMoreLoading.value = false;
    }
  }

  /// 🔄 Pull-to-refresh / manual reload
  Future<void> refreshCards() async {
    await loadHomeData();
  }
}
