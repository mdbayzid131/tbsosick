import 'dart:io';

import 'package:get/get.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/user_model.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';

class ProfileController extends GetxController {
  final UserDataRepository _userDataRepository = Get.find();
  final Rx<UserModel> user = UserModel().obs;
  final Rx<bool> isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfileData();
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
        Helpers.showCustomSnackBar(
          'Profile updated successfully',
          isError: false,
        );
        await getProfileData(); // Refresh data
      }
    } catch (e) {
      Helpers.showDebugLog("updateProfile error => $e");
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
}
