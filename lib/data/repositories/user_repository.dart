
// ignore: implementation_imports
import 'package:dio/src/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:tbsosick/config/constants/api_constants.dart';
import 'package:tbsosick/core/services/api_client.dart';

class UserDataRepository {
  final ApiClient _apiClient = Get.find();

  // Get user profile
  Future<Response<dynamic>> getProfile() async {
    return await _apiClient.getData(ApiConstants.profile);
  }

  // Get all preference card count
  Future<Response<dynamic>> getCardCount() async {
    return await _apiClient.getData(ApiConstants.getCardCount);
  }

  // Get all preference card
  Future<Response<dynamic>> getAllCard() async {
    return await _apiClient.getData(ApiConstants.getAllCard);
  }

  // Get all public preference card
  Future<Response<dynamic>> getPublicCard({int page = 1}) async {
    return await _apiClient.getData(ApiConstants.getPublicCard, query: {'page': page, 'limit': 10});
  }

  // Get all private preference card
  Future<Response<dynamic>> getPrivateCard() async {
    return await _apiClient.getData(ApiConstants.getPrivateCard);
  }

  // // Update user profile
  // Future<Response<dynamic>> updateProfile({
  //   required String name,
  //   String? phone,
  // }) async {
  //   return await _apiClient.putData(
  //     ApiConstants.profile,
  //     {
  //       'name': name,
  //       'phone': phone,
  //     },
  //   );
  // }
}
