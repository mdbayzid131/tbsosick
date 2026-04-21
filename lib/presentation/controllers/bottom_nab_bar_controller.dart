import 'package:get/get.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/card_count_model.dart';
import 'package:tbsosick/data/models/favorite_Card_model.dart';
import 'package:tbsosick/data/models/private_card_model.dart';
import 'package:tbsosick/data/models/public_card_model.dart';
import 'package:tbsosick/data/models/user_model.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';

class BottomNabBarController extends GetxController {
  final UserDataRepository _userDataRepository = UserDataRepository();

  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  // data list
  final RxList<PublicCard> publicCards = <PublicCard>[].obs;
  // card list
  final RxList<PrivateCard> privateCards = <PrivateCard>[].obs;
  // favorite cards
  final RxList<FavoriteCard> favoriteCards = <FavoriteCard>[].obs;
  // user data
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  // card count
  final Rx<CardCountModel?> cardCount = Rx<CardCountModel?>(null);

  // error message (optional)
  final RxString errorMessage = ''.obs;

  // loading states
  final RxBool isLoading = false.obs;
  final RxBool isPublicMoreLoading = false.obs;
  final RxBool isPrivateMoreLoading = false.obs;
  final RxBool isFavoriteMoreLoading = false.obs;



  // pagination
  int _publicPage = 1;
  int _privatePage = 1;
  int _favoritePage = 1;
  final RxBool hasMoreFavorite = true.obs;
  final RxBool hasMorePublic = true.obs;
  final RxBool hasMorePrivate = true.obs;

  // Search
  final RxString searchController = ''.obs;

  // Filters
  final RxString specialtyFilter = 'All'.obs;
  final RxBool verifiedOnlyFilter = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
    debounce(searchController, (_) {
      refreshCards();
    }, time: const Duration(milliseconds: 500));
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        getProfile(showLoading: false),
        getAllCardCount(showLoading: false),
        getPrivateCard(showLoading: false),
        getPublicCard(showLoading: false),
        getFavoriteCard(showLoading: false),
      ]);
    } catch (e) {
      Helpers.showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPublicCard({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      _publicPage = 1;

      final response = await _userDataRepository.getPublicCard(
        page: _publicPage,
        search: searchController.value,
        specialty:
            specialtyFilter.value == 'All' ? '' : specialtyFilter.value,
        verificationStatus:
            verifiedOnlyFilter.value ? 'VERIFIED' : '',
      );
      ApiChecker.checkGetApi(response);
      if (response.statusCode == 200) {
        if (response.data != null) {
          // API response might be nested under 'data' or flat
          final Map<String, dynamic> data =
              (response.data['data'] is Map<String, dynamic>)
              ? response.data['data']
              : response.data;

          final result = PublicCardsResponse.fromJson(data);
          publicCards.assignAll(result.data);
          hasMorePublic.value = _publicPage < result.pagination.totalPage;
        }
      }
    } catch (e) {
      Helpers.showDebugLog("Error loading public cards: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> loadMorePublic() async {
    if (!hasMorePublic.value || isPublicMoreLoading.value) return;

    try {
      isPublicMoreLoading.value = true;
      _publicPage++;

      final response = await _userDataRepository.getPublicCard(
        page: _publicPage,
        search: searchController.value,
        specialty:
            specialtyFilter.value == 'All' ? '' : specialtyFilter.value,
        verificationStatus:
            verifiedOnlyFilter.value ? 'VERIFIED' : '',
      );
      ApiChecker.checkGetApi(response);
      if (response.statusCode == 200) {
        if (response.data != null) {
          final Map<String, dynamic> data =
              (response.data['data'] is Map<String, dynamic>)
              ? response.data['data']
              : response.data;
          final result = PublicCardsResponse.fromJson(data);
          publicCards.addAll(result.data);
          hasMorePublic.value = _publicPage < result.pagination.totalPage;
        }
      }
    } catch (e) {
      _publicPage--; // rollback
      Helpers.showDebugLog("Error loading more public cards: $e");
    } finally {
      isPublicMoreLoading.value = false;
    }
  }

  ///================================================

  Future<void> getProfile({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      errorMessage.value = '';
      final response = await _userDataRepository.getProfile();
      ApiChecker.checkGetApi(response);

      if (response.statusCode == 200 && response.data != null) {
        user.value = UserModel.fromJson(response.data['data']);
      }
    } catch (e) {
      Helpers.showDebugLog("Error loading profile: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  ///================================================
  Future<void> getAllCardCount({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      errorMessage.value = '';
      final response = await _userDataRepository.getCardCount();
      ApiChecker.checkGetApi(response);

      cardCount.value = CardCountModel.fromJson(response.data['data']);
    } catch (e) {
      Helpers.showDebugLog("Error loading card count: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }


  /// 🔥 GET PRIVATE CARDS
  Future<void> getPrivateCard({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      _privatePage = 1;
      errorMessage.value = '';

      final response = await _userDataRepository.getPrivateCard(
        page: _privatePage,
        search: searchController.value,
        specialty:
            specialtyFilter.value == 'All' ? '' : specialtyFilter.value,
        verificationStatus:
            verifiedOnlyFilter.value ? 'VERIFIED' : '',
      );
      ApiChecker.checkGetApi(response);
      if (response.statusCode == 200 && response.data != null) {
        // API response might be nested under 'data' or flat
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
            ? response.data['data']
            : response.data;

        final result = PrivateCardsResponse.fromJson(data);

        privateCards.assignAll(result.data);
        hasMorePrivate.value = _privatePage < result.pagination.totalPage;
      }
    } catch (e) {
      Helpers.showDebugLog("Error loading private cards: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> loadMorePrivate() async {
    if (!hasMorePrivate.value || isPrivateMoreLoading.value) return;

    try {
      isPrivateMoreLoading.value = true;
      _privatePage++;

      final response = await _userDataRepository.getPrivateCard(
        page: _privatePage,
        search: searchController.value,
        specialty:
            specialtyFilter.value == 'All' ? '' : specialtyFilter.value,
        verificationStatus:
            verifiedOnlyFilter.value ? 'VERIFIED' : '',
      );
      ApiChecker.checkGetApi(response);

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
            ? response.data['data']
            : response.data;
        final result = PrivateCardsResponse.fromJson(data);
        privateCards.addAll(result.data);
        hasMorePrivate.value = _privatePage < result.pagination.totalPage;
      }
    } catch (e) {
      _privatePage--; // rollback
      Helpers.showDebugLog("Error loading more private cards: $e");
    } finally {
      isPrivateMoreLoading.value = false;
    }
  }
  


  /// 🔥 GET FAVORITE CARDS
  Future<void> getFavoriteCard({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
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
      Helpers.showDebugLog("Error loading favorite cards: $e");
    } finally {
      if (showLoading) isLoading.value = false;
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
      Helpers.showDebugLog("Error loading more favorite cards: $e");
    } finally {
      isFavoriteMoreLoading.value = false; 
    }
  }




  /// 🔄 Pull-to-refresh / manual reload
  Future<void> refreshCards() async {
    await loadHomeData();
  }
}
