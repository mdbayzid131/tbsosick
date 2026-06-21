import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/services/notification_service.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/card_details_model.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';
import 'package:tbsosick/core/services/pdf_service.dart';

class PrefranceCardDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isDownloading = false.obs;
  RxBool isSharing = false.obs;
  final UserDataRepository _userRepository = UserDataRepository();
  final Rx<PreferenceCardDetailsModel?> cardDetails =
      Rx<PreferenceCardDetailsModel?>(null);

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
      Helpers.error("getCardDetails error => $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadCard({required String cardId}) async {
    try {
      isDownloading.value = true;
      Helpers.showSuccess("Download started...");

      // Fetch card details if missing or different
      PreferenceCardDetailsModel? card = cardDetails.value;
      if (card == null || card.id != cardId) {
        final response = await _userRepository.getCardDetails(cardId: cardId);
        if (response.statusCode == 200) {
          final data = PreferenceCardDetailsResponse.fromJson(response.data);
          card = data.data;
        } else {
          throw Exception("Failed to fetch card details");
        }
      }

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
        // Count download via API
        await _userRepository.downloadCard(cardId: cardId);

        final dir = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();

        final filePath = '${dir!.path}/PreferenceCard_$cardId.pdf';

        // Generate PDF locally
        final file = await PdfService().generatePreferenceCardPdf(
          card,
          filePath,
        );

        if (Platform.isAndroid) {
          await _notificationService.showDownloadNotification(
            filePath: file.path,
            fileName: 'PreferenceCard_$cardId.pdf',
          );
          Helpers.showSuccess(
            "PDF downloaded successfully! Tap the notification to view.",
          );
        } else if (Platform.isIOS) {
          await OpenFile.open(file.path);
          Helpers.showSuccess("PDF generated successfully!");
        }
      } else {
        Helpers.showError(
          "Storage permission is required to download the card.",
        );
      }
    } catch (e) {
      Helpers.error("downloadCard error => $e");
      Helpers.showError("Download failed: $e");
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> shareCard() async {
    try {
      final card = cardDetails.value;
      if (card != null) {
        isSharing.value = true;
        Helpers.showSuccess("Preparing card for sharing...");

        // Count download via API
        await _userRepository.downloadCard(cardId: card.id);

        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/PreferenceCard_${card.id}.pdf';

        // Generate PDF locally
        final file = await PdfService().generatePreferenceCardPdf(
          card,
          filePath,
        );

        await Share.shareXFiles([
          XFile(file.path),
        ], text: 'Check out this preference card: ${card.cardTitle}');
      }
    } catch (e) {
      Helpers.error("shareCard error => $e");
      Helpers.showError("Failed to prepare card for sharing.");
    } finally {
      isSharing.value = false;
    }
  }

  Future<void> copyCardId({required String cardId}) async {
    try {
      await Clipboard.setData(ClipboardData(text: cardId));
    } catch (e) {
      Helpers.error("copyCardId error => $e");
    }
  }
}
