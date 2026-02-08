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
  final RxBool isMoreLoading = false.obs;

  // pagination
  int _page = 1;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
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

      final response = await _userDataRepository.getPublicCard(page: _page);
      ApiChecker.checkApi(response);

      final result = PublicCardsResponse.fromJson(response.data);

      publicCards.assignAll(result.data);

      _hasMore = _page < result.pagination.totalPage;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || isMoreLoading.value) return;

    try {
      isMoreLoading.value = true;
      _page++;

      final response = await _userDataRepository.getPublicCard(page: _page);
      ApiChecker.checkApi(response);

      final result = PublicCardsResponse.fromJson(response.data);

      publicCards.addAll(result.data);

      _hasMore = _page < result.pagination.totalPage;
    } catch (e) {
      _page--; // rollback
    } finally {
      isMoreLoading.value = false;
    }
  }

  void refreshList() {
    _page = 1;
    _hasMore = true;
    publicCards.clear();
    getPublicCard();
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

      final response = await _userDataRepository.getAllCard(page: _page);
      ApiChecker.checkApi(response);
      if (response.statusCode == 200 && response.data != null) {
        final result = AllCardsResponse.fromJson(response.data);

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
      errorMessage.value = '';

      final response = await _userDataRepository.getPrivateCard(page: _page);
      ApiChecker.checkApi(response);
      if (response.statusCode == 200 && response.data != null) {
        final result = PrivateCardsResponse.fromJson(response.data);

        privateCards.assignAll(result.data);
      } else {
        errorMessage.value = 'Failed to load private cards';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      if (showLoading) isLoading.value = false;
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


