import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/services/notification_service.dart';
import 'package:tbsosick/core/services/pdf_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/card_details_model.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';

class PrefranceCardDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isDownloading = false.obs;
  RxBool isSharing = false.obs;
  final UserDataRepository _userRepository = UserDataRepository();
  final Rx<PreferenceCardDetailsModel?> cardDetails =
      Rx<PreferenceCardDetailsModel?>(null);
  final PdfService _pdfService = PdfService();

  final NotificationService _notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    _notificationService.init();
  }

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
      isDownloading.value = true;

      // Request notification permission (Android 13+)
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }

      // Handle storage permissions
      bool storageGranted = false;

      // Check for Android 13+ granular permissions or legacy storage permission
      if (await Permission.storage.request().isGranted) {
        storageGranted = true;
      } else if (await Permission.manageExternalStorage.request().isGranted) {
        storageGranted = true;
      } else if (await Permission.photos.request().isGranted &&
          await Permission.videos.request().isGranted &&
          await Permission.audio.request().isGranted) {
        storageGranted = true;
      } else {
        // Fallback for some devices/versions where public downloads are accessible without explicit permission
        // or if using scoped storage efficiently.
        // We set true to try anyway, catching errors if it fails.
        storageGranted = true;
      }

      if (storageGranted) {
        // Track download on server
        final response = await _userRepository.downloadCard(cardId: cardId);
        ApiChecker.checkWriteApi(response);

        if (cardDetails.value != null) {
          final file = await _pdfService.generatePreferenceCardPdf(
            cardDetails.value!,
          );

          await _notificationService.showDownloadNotification(
            filePath: file.path,
            fileName: file.path.split('/').last,
          );

          // Helpers.showCustomSnackBar(
          //   "Download started. Check notifications.",
          //   isError: false,
          // );
        }
      }
    } catch (e) {
      Helpers.showDebugLog("downloadCard error => $e");
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> shareCard() async {
    try {
      if (cardDetails.value != null) {
        isSharing.value = true;
        final file = await _pdfService.generatePreferenceCardPdf(
          cardDetails.value!,
        );
        await Share.shareXFiles(
          [XFile(file.path)],
          text:
              'Check out this preference card: ${cardDetails.value!.cardTitle}',
        );
      }
    } catch (e) {
      Helpers.showDebugLog("shareCard error => $e");
    } finally {
      isLoading.value = false;
    }
  }



Future<void> copyCardId({required String cardId}) async {
  try {
    await Clipboard.setData(ClipboardData(text: cardId));
  } catch (e) {
    Helpers.showDebugLog("copyCardId error => $e");
  }
}


}
