 import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';

class ProfileController extends GetxController {
  final UserDataRepository _userDataRepository = Get.find();
  final Rx<bool> isLoading = false.obs;
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
      ApiChecker.checkApi(response);
      if (response.statusCode == 200) {
        Helpers.showSuccessSnackbar('Profile updated successfully');
      }
    } catch (e) {
      Helpers.showErrorSnackbar(e.toString());
    }
    finally {
      isLoading.value = false;
    }
  }
}
