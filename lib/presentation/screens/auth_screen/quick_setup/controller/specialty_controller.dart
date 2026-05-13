import 'package:get/get.dart';
import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/specialty_model.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';

class SpecialtyController extends GetxController {
  final UserDataRepository _userDataRepository = UserDataRepository();

  final RxList<Specialty> specialties = <Specialty>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    fetchSpecialties();
  }

  Future<void> fetchSpecialties() async {
    try {
      isLoading.value = true;
      final response = await _userDataRepository.getSpecialties();
      ApiChecker.checkGetApi(response);
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'] ?? [];
        specialties.assignAll(data.map((e) => Specialty.fromJson(e)).toList());
      }
    } catch (e) {
      Helpers.error("Error fetching specialties: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectSpecialty(int index) {
    selectedIndex.value = index;
  }

  String getSelectedSpecialtyName() {
    if (selectedIndex.value != -1 && selectedIndex.value < specialties.length) {
      return specialties[selectedIndex.value].name;
    }
    return '';
  }
}
