import 'package:get/get.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/card_details_model.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';

class PrefranceCardDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  final UserDataRepository _userRepository = UserDataRepository();
  final Rx<PreferenceCardDetailsModel?> cardDetails =
      Rx<PreferenceCardDetailsModel?>(null);

  Future<void> getCardDetails({required String cardId}) async {
    try {
      isLoading.value = true;
      final response = await _userRepository.getCardDetails(cardId: cardId);
      ApiChecker.checkGetApi(response);
      if (response.statusCode == 200) {
        final data = PreferenceCardDetailsResponse.fromJson(response.data);
        cardDetails.value = data.data;
      }
    } catch (e) {
      Helpers.showDebugLog("getCardDetails error => $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadCard({required String cardId}) async {
    try {
      isLoading.value = true;
      final response = await _userRepository.downloadCard(cardId: cardId);
      ApiChecker.checkGetApi(response);
      if (response.statusCode == 200) {
        Helpers.showCustomSnackBar("Card downloaded successfully", isError: false);
      }
    } catch (e) {
      Helpers.showDebugLog("downloadCard error => $e");
    } finally {
      isLoading.value = false;
    }
  }
}
