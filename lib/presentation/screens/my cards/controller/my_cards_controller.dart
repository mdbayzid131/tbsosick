import 'package:get/get.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/library_card_model.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';

class MyCardsController extends GetxController {
  final UserDataRepository _userDataRepository = UserDataRepository();

  final RxList<LibraryCard> myCards = <LibraryCard>[].obs;
  final RxString searchController = ''.obs;
  final RxString selectedVisibility = 'public'.obs; // 'public' or 'private'
  final RxString errorMessage = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxBool hasMoreCards = true.obs;

  int _page = 1;

  @override
  void onInit() {
    super.onInit();
    fetchCards();
    debounce(searchController, (_) {
      fetchCards();
    }, time: const Duration(milliseconds: 500));
  }

  void changeVisibility(String visibility) {
    if (selectedVisibility.value != visibility) {
      selectedVisibility.value = visibility;
      fetchCards();
    }
  }

  Future<void> fetchCards({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      _page = 1;
      errorMessage.value = '';

      final response = await _userDataRepository.getMyCards(
        page: _page,
        search: searchController.value,
        visibility: selectedVisibility.value,
      );

      ApiChecker.checkGetApi(response);
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
                ? response.data['data']
                : response.data;
        
        final result = LibraryCardsResponse.fromJson(data);
        myCards.assignAll(result.data);
        hasMoreCards.value = _page < result.meta.totalPages;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Helpers.showDebugLog("Error loading my cards: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> loadMoreCards() async {
    if (!hasMoreCards.value || isMoreLoading.value) return;

    try {
      isMoreLoading.value = true;
      _page++;

      final response = await _userDataRepository.getMyCards(
        page: _page,
        search: searchController.value,
        visibility: selectedVisibility.value,
      );

      ApiChecker.checkGetApi(response);
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data =
            (response.data['data'] is Map<String, dynamic>)
                ? response.data['data']
                : response.data;
                
        final result = LibraryCardsResponse.fromJson(data);
        myCards.addAll(result.data);
        hasMoreCards.value = _page < result.meta.totalPages;
      }
    } catch (e) {
      _page--; // rollback
      Helpers.showDebugLog("Error loading more my cards: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }

  Future<void> refreshCards() async {
    await fetchCards();
  }
}