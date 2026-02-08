import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';

class PostAnyCardController extends GetxController {
  final UserDataRepository userDataRepository = UserDataRepository();
  RxBool isLoading = false.obs;

  RxList<String> selectedSupplies = <String>[].obs;
  RxList<String> selectedSutures = <String>[].obs;

  final ImagePicker picker = ImagePicker();
  RxList<File> selectedImages = <File>[].obs;

  Future<void> pickImages() async {
    final List<XFile> images = await picker
        .pickMultiImage(); // pickMultiImage returns List<XFile>
    if (images.isNotEmpty) {
      if (images.length > 5) {
        Helpers.showErrorSnackbar('You can only select up to 5 images');
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
    selectedSutures.clear();
    selectedImages.clear();
  }

  Future<void> submitPreferenceCard(bool isprivate) async {
    try {
      isLoading.value = true;

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
        supplies: selectedSupplies,
        sutures: selectedSutures,
        instruments: instrumentController.text,
        positioningEquipment: postingEquipmentController.text,
        prepping: positionController.text,
        workflow: operativeWorkFlowController.text,
        keyNotes: keyNotesController.text,
        published: !isprivate,
        photos: selectedImages, // List<File>
      );

      ApiChecker.checkApi(response);

      Helpers.showSuccessSnackbar('Preference card created');
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
