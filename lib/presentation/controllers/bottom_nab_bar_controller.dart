import 'package:get/get.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/all_cards_model.dart';
import 'package:tbsosick/data/models/card_count_model.dart';
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
  // all cards list
  final RxList<PreferenceCard> allCards = <PreferenceCard>[].obs;
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

  // pagination
  int _publicPage = 1;
  int _privatePage = 1;
  final RxBool hasMorePublic = true.obs;
  final RxBool hasMorePrivate = true.obs;

  // Search
  final RxString searchController = ''.obs;

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
        getAllCard(showLoading: false),
        getPrivateCard(showLoading: false),
        getPublicCard(showLoading: false),
      ]);
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
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
      );
      ApiChecker.checkApi(response);

      if (response.data != null) {
        print("Public Card Response: ${response.data}");
        // API response might be nested under 'data' or flat
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
            ? response.data['data']
            : response.data;

        final result = PublicCardsResponse.fromJson(data);
        publicCards.assignAll(result.data);
        hasMorePublic.value = _publicPage < result.pagination.totalPage;
        print("Public Cards Loaded: ${publicCards.length}");
      }
    } catch (e) {
      print("Error loading public cards: $e");
      Get.snackbar('Error', e.toString());
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
      );
      ApiChecker.checkApi(response);

      if (response.data != null) {
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
            ? response.data['data']
            : response.data;
        final result = PublicCardsResponse.fromJson(data);
        publicCards.addAll(result.data);
        hasMorePublic.value = _publicPage < result.pagination.totalPage;
      }
    } catch (e) {
      _publicPage--; // rollback
      print("Error loading more public cards: $e");
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
      ApiChecker.checkApi(response);

      if (response.statusCode == 200 && response.data != null) {
        user.value = UserModel.fromJson(response.data['data']);
      } else {
        errorMessage.value = 'Failed to load profile';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Helpers.showErrorSnackbar(e.toString());
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
      ApiChecker.checkApi(response);

      cardCount.value = CardCountModel.fromJson(response.data['data']);
    } catch (e) {
      errorMessage.value = e.toString();
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  ///================================================

  Future<void> getAllCard({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      errorMessage.value = '';

      final response = await _userDataRepository.getAllCard(page: 1);
      ApiChecker.checkApi(response);
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
            ? response.data['data']
            : response.data;
        final result = AllCardsResponse.fromJson(data);

        allCards.assignAll(result.data);
      } else {
        errorMessage.value = 'Failed to load all cards';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Helpers.showErrorSnackbar(e.toString());
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
      );
      ApiChecker.checkApi(response);
      if (response.statusCode == 200 && response.data != null) {
        print("Private Card Response: ${response.data}");
        // API response might be nested under 'data' or flat
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
            ? response.data['data']
            : response.data;

        final result = PrivateCardsResponse.fromJson(data);

        privateCards.assignAll(result.data);
        hasMorePrivate.value = _privatePage < result.pagination.totalPage;
        print("Private Cards Loaded: ${privateCards.length}");
      } else {
        errorMessage.value = 'Failed to load private cards';
      }
    } catch (e) {
      print("Error loading private cards: $e");
      errorMessage.value = e.toString();
      Helpers.showErrorSnackbar(e.toString());
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
      );
      ApiChecker.checkApi(response);

      if (response.data != null) {
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
      print("Error loading more private cards: $e");
    } finally {
      isPrivateMoreLoading.value = false;
    }
  }

  /// 🔄 Pull-to-refresh / manual reload
  Future<void> refreshCards() async {
    await loadHomeData();
  }
}



  // RxInt currentIndex = 0.obs;
  //
  // final List<GlobalKey<NavigatorState>> navigatorKeys =
  // List.generate(4, (_) => GlobalKey<NavigatorState>());
  //
  // void changePage(int index) {
  //   if (currentIndex.value == index) {
  //     navigatorKeys[index]
  //         .currentState
  //         ?.popUntil((route) => route.isFirst);
  //   } else {
  //     navigatorKeys[currentIndex.value]
  //         .currentState
  //         ?.popUntil((route) => route.isFirst);
  //
  //     currentIndex.value = index;
  //   }
  // }
  //
  // Future<bool> onWillPop() async {
  //   final NavigatorState currentNavigator =
  //   navigatorKeys[currentIndex.value].currentState!;
  //
  //   if (currentNavigator.canPop()) {
  //     currentNavigator.pop();
  //     return false;
  //   }
  //   return true;
  // }


