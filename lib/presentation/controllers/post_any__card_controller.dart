import 'package:get/get.dart';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tbsosick/config/routes/app_pages.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/core/utils/subscription_helper.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';
import 'package:tbsosick/presentation/controllers/homepage_controller.dart';

class PostAnyCardController extends GetxController {
  final UserDataRepository userDataRepository = UserDataRepository();
  final HomePageController homePageController = Get.find();
  RxBool isLoading = false.obs;

  RxList<Map<String, dynamic>> selectedSupplies = <Map<String, dynamic>>[].obs;
  RxMap<String, String> selectedSuppliesNames = <String, String>{}.obs;
  RxList<Map<String, dynamic>> selectedSutures = <Map<String, dynamic>>[].obs;
  RxMap<String, String> selectedSuturesNames = <String, String>{}.obs;

  final ImagePicker picker = ImagePicker();
  RxList<File> selectedImages = <File>[].obs;

  Future<void> pickImages() async {
    final List<XFile> images = await picker
        .pickMultiImage(); // pickMultiImage returns List<XFile>
    if (images.isNotEmpty) {
      if (images.length > 5) {
        Helpers.showError('You can only select up to 5 images');
      }
      // Take at most 5 images
      final limitedImages = images.take(5).toList();
      selectedImages.assignAll(limitedImages.map((e) => File(e.path)).toList());
    }
  }

  final TextEditingController cardTitleController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController handpreferenceController =
      TextEditingController();
  final TextEditingController specialitiesController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController musicPreferenceController =
      TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController instrumentController = TextEditingController();
  final TextEditingController postingEquipmentController =
      TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController operativeWorkFlowController =
      TextEditingController();
  final TextEditingController keyNotesController = TextEditingController();

  void clearAllControllers() {
    cardTitleController.clear();
    fullNameController.clear();
    handpreferenceController.clear();
    specialitiesController.clear();
    contactController.clear();
    musicPreferenceController.clear();
    medicationController.clear();
    instrumentController.clear();
    postingEquipmentController.clear();
    positionController.clear();
    operativeWorkFlowController.clear();
    keyNotesController.clear();
    selectedSupplies.clear();
    selectedSuppliesNames.clear();
    selectedSutures.clear();
    selectedSuturesNames.clear();
    selectedImages.clear();
  }

  Future<void> submitPreferenceCard(bool isprivate) async {
    try {
      isLoading.value = true;

      // Map IDs to names for supplies
      final mappedSupplies = selectedSupplies.map((item) {
        final id = item['name'];
        final name =
            selectedSuppliesNames[id] ??
            homePageController.supplies
                .firstWhereOrNull((e) => e.id == id)
                ?.name ??
            id;
        return {'name': name, 'quantity': item['quantity']};
      }).toList();

      // Map IDs to names for sutures
      final mappedSutures = selectedSutures.map((item) {
        final id = item['name'];
        final name =
            selectedSuturesNames[id] ??
            homePageController.sutures
                .firstWhereOrNull((e) => e.id == id)
                ?.name ??
            id;
        return {'name': name, 'quantity': item['quantity']};
      }).toList();

      final response = await userDataRepository.createPreferenceCard(
        cardTitle: cardTitleController.text,
        surgeon: {
          'fullName': fullNameController.text,
          'handPreference': handpreferenceController.text,
          'specialty': specialitiesController.text,
          'contactNumber': contactController.text,
          'musicPreference': musicPreferenceController.text,
        },
        medication: medicationController.text,
        supplies: mappedSupplies,
        sutures: mappedSutures,
        instruments: instrumentController.text,
        positioningEquipment: postingEquipmentController.text,
        prepping: positionController.text,
        workflow: operativeWorkFlowController.text,
        keyNotes: keyNotesController.text,
        visibility: isprivate ? 'PRIVATE' : 'PUBLIC',
        photos: selectedImages, // List<File>
      );
      if (response.statusCode == 403 || response.statusCode == 402) {
        SubscriptionHelper.showSubscriptionDialog(
          title: 'Subscription Required',
          message: response.data?['message'] ?? '',
          onPress: () {
            Get.back();
            Get.toNamed(AppRoutes.subscription);
          },
        );
      } else {
        ApiChecker.checkWriteApi(response);
      }
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        Get.back();

        isprivate
            ? Helpers.showSuccess('Private card save Successfully')
            : Helpers.showSuccess('Preference card created Successfully');
      }
    } catch (e) {
      Helpers.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
