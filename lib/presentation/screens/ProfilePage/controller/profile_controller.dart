import 'dart:io';

import 'package:get/get.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/legal_page_model.dart';
import 'package:tbsosick/data/models/user_model.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';

class ProfileController extends GetxController {
  final UserDataRepository _userDataRepository = Get.find();
  final Rx<UserModel> user = UserModel().obs;
  final Rx<bool> isLoading = false.obs;

  final RxList<LegalPage> legalPages = <LegalPage>[].obs;
  final RxBool isLegalPagesLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfileData();
    fetchLegalPages();
  }

  Future<void> getProfileData() async {
    try {
      isLoading.value = true;
      final response = await _userDataRepository.getProfile();
      if (response.statusCode == 200) {
        user.value = UserModel.fromJson(response.data['data']);
      }
    } catch (e) {
      Helpers.showDebugLog("getProfileData error => $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String specialty,
    required String hospital,
    required String email,
  }) async {
    try {
      isLoading.value = true;
      final response = await _userDataRepository.updateProfile(
        name: name,
        phone: phone,
        specialty: specialty,
        hospital: hospital,
        email: email,
      );
      ApiChecker.checkWriteApi(response);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        Helpers.showSuccess('Profile updated successfully');
        await getProfileData(); // Refresh data
      }
    } catch (e) {
      Helpers.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    try {
      isLoading.value = true;
      final response = await _userDataRepository.updateProfileImage(
        imageFile: imageFile,
      );
      ApiChecker.checkWriteApi(response);
      if (response.statusCode == 200) {
        await getProfileData(); // Refresh data
      }
    } catch (e) {
      Helpers.showDebugLog("updateProfileImage error => $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLegalPages() async {
    try {
      isLegalPagesLoading.value = true;
      final response = await _userDataRepository.getLegalPages();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        legalPages.value = data.map((e) => LegalPage.fromJson(e)).toList();
      }
    } catch (e) {
      Helpers.showDebugLog("fetchLegalPages error => $e");
    } finally {
      isLegalPagesLoading.value = false;
    }
  }

  Future<LegalPageDetails?> fetchLegalPageDetails(String slug) async {
    try {
      final response = await _userDataRepository.getLegalPageDetails(slug: slug);
      if (response.statusCode == 200) {
        return LegalPageDetails.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      Helpers.showDebugLog("fetchLegalPageDetails error => $e");
      return null;
    }
  }
}
