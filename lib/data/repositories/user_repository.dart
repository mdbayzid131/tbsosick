import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:tbsosick/config/constants/api_constants.dart';
import 'package:tbsosick/core/services/api_client.dart';
import 'package:tbsosick/data/models/create_event_request_model.dart';

class UserDataRepository {
  final ApiClient _apiClient = Get.find();
  final Dio dio = Dio();

  // Get user profile
  Future<Response<dynamic>> getProfile() async {
    return await _apiClient.getData(ApiConstants.profile);
  }

  // Get all preference card count
  Future<Response<dynamic>> getCardCount() async {
    return await _apiClient.getData(ApiConstants.getCardCount);
  }

  // Get all preference card
  Future<Response<dynamic>> getAllCard({int page = 1}) async {
    return await _apiClient.getData(
      ApiConstants.getAllCard,
      query: {'page': page, 'limit': 10},
    );
  }

  // Get all public preference card
  Future<Response<dynamic>> getPublicCard({
    int page = 1,
    String search = '',
    String specialty = '',
    String verificationStatus = '',
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': 10,
      'searchTerm': search,
    };
    if (specialty.isNotEmpty) {
      query['specialty'] = specialty;
    }
    if (verificationStatus.isNotEmpty) {
      query['verificationStatus'] = verificationStatus;
    }
    return await _apiClient.getData(
      ApiConstants.getPublicCard,
      query: query,
    );
  }

  // Get all private preference card
  Future<Response<dynamic>> getPrivateCard({
    int page = 1,
    String search = '',
    String specialty = '',
    String verificationStatus = '',
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': 10,
      'searchTerm': search,
    };
    if (specialty.isNotEmpty) {
      query['specialty'] = specialty;
    }
    if (verificationStatus.isNotEmpty) {
      query['verificationStatus'] = verificationStatus;
    }
    return await _apiClient.getData(
      ApiConstants.getPrivateCard,
      query: query,
    );
  }

  // Get all favorite preference card
  Future<Response<dynamic>> getFavoriteCard({
    int page = 1,
    // String search = '',
    // String specialty = '',
    // String verificationStatus = '',
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': 10,
      // 'searchTerm': search,
    };
    // if (specialty.isNotEmpty) {
    //   query['specialty'] = specialty;
    // }
    // if (verificationStatus.isNotEmpty) {
    //   query['verificationStatus'] = verificationStatus;
    // }
    return await _apiClient.getData(
      ApiConstants.getFavoriteCard,
      query: query,
    );
  }

  Future<Response<dynamic>> getCardDetails({required String cardId}) async {
    return await _apiClient.getData(
      ApiConstants.getCardDetails.replaceAll('{id}', cardId),
    );
  }

  Future<Response<dynamic>> downloadCard({required String cardId}) async {
    return await _apiClient.postData(
      ApiConstants.downloadCard.replaceAll('{id}', cardId),
      {},
    );
  }

  Future<Response<dynamic>> getSupplies({String search = ''}) async {
    return await _apiClient.getData(
      ApiConstants.getSuppliesList,
      query: {'searchTerm': search},
    );
  }

  Future<Response<dynamic>> getSutures({String search = ''}) async {
    return await _apiClient.getData(
      ApiConstants.getSuturesList,
      query: {'searchTerm': search},
    );
  }

  Future<Response<dynamic>> addToFavoriteList({required String cardId}) async {
    return await _apiClient.postData(
      ApiConstants.addToFavoriteList.replaceAll('{id}', cardId),
      {},
    );
  }

  Future<Response<dynamic>> removeFromFavoriteList({required String cardId}) async {
    return await _apiClient.deleteData(
      ApiConstants.removeFromFavoriteList.replaceAll('{id}', cardId),
      
    );
  }

  Future<Response> createPreferenceCard({
    required String cardTitle,
    required Map<String, dynamic> surgeon,
    required String medication,
    required List<String> supplies,
    required List<String> sutures,
    required String instruments,
    required String positioningEquipment,
    required String prepping,
    required String workflow,
    required String keyNotes,
    required bool published,
    required List<File> photos,
  }) async {
    // 1. Build the data map (flat fields + list items)
    final Map<String, dynamic> body = {
      'cardTitle': cardTitle,
      'medication': medication,
      'instruments': instruments,
      'positioningEquipment': positioningEquipment,
      'prepping': prepping,
      'workflow': workflow,
      'keyNotes': keyNotes,
      'published': published.toString(),
    };

    // Flatten surgeon map
    surgeon.forEach((key, value) {
      body['surgeon[$key]'] = value;
    });

    // Add list items (using list values, Dio FormData.fromMap handles them)
    // To ensure key[] syntax, we use that as the key name.
    body['supplies[]'] = supplies;
    body['sutures[]'] = sutures;

    // 2. Prepare files for multipartBody
    List<MultipartBody> multipartConfig = photos.map((file) {
      return MultipartBody("photoLibrary", file);
    }).toList();

    // 3. Send using postMultipartData
    return await _apiClient.postMultipartData(
      ApiConstants.getAllCard,
      body,
      multipartBody: multipartConfig,
    );
  }

  // Event Endpoints
  Future<Response<dynamic>> getEventsList() async {
    return await _apiClient.getData(ApiConstants.getEventsList);
  }

  // Get event detail by id
  Future<Response<dynamic>> getEventDetailById({required String id}) async {
    return await _apiClient.getData(
      ApiConstants.getEventDetailById.replaceAll('{id}', id),
    );
  }

  // Create event
  Future<Response> createEvent(CreateEventRequestModel model) async {
    return await _apiClient.postData(ApiConstants.postEvent, model.toJson());
  }

  // Update event
  Future<Response<dynamic>> patchEvent({
    required String id,
    required CreateEventRequestModel model,
  }) async {
    return await _apiClient.patchData(
      ApiConstants.patchEvent.replaceAll('{id}', id),
      model.toJson(),
    );
  }

  // Delete event
  Future<Response<dynamic>> deleteEvent({required String id}) async {
    return await _apiClient.deleteData(
      ApiConstants.deleteEvent.replaceAll('{id}', id),
    );
  }

  // Update profile
  Future<Response> updateProfile({
    required String name,
    required String phone,
    required String specialty,
    required String hospital,
    required String email,
  }) async {
    return await _apiClient.patchData(ApiConstants.profile, {
      "name": name,
      "phone": phone,
      "specialty": specialty,
      "hospital": hospital,
      "email": email,
    });
  }

  // Update profile image (multipart)
  Future<Response> updateProfileImage({required File imageFile}) async {
    return await _apiClient.patchMultipartData(
      ApiConstants.profile,
      {},
      multipartBody: [MultipartBody('profilePicture', imageFile)],
    );
  }
}
