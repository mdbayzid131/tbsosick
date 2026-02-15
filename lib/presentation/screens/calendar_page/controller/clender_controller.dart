import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:tbsosick/core/services/api_checker.dart';
import 'package:tbsosick/core/utils/helpers.dart';
import 'package:tbsosick/data/models/create_event_request_model.dart';
import 'package:tbsosick/data/models/event_details_model.dart';
import 'package:tbsosick/data/models/event_model.dart';
import 'package:tbsosick/data/repositories/user_repository.dart';

class CalendarController extends GetxController {
  final RxBool isLoading = false.obs;
  final UserDataRepository _userDataRepository = Get.find();
  final RxList<EventModel> events = <EventModel>[].obs;
  final Rx<EventDetailsModel?> eventDetails = Rx<EventDetailsModel?>(null);

  Future<void> getEvents() async {
    try {
      isLoading.value = true;
      final response = await _userDataRepository.getEventsList();
      ApiChecker.checkApi(response);

      if (response.statusCode == 200) {
        final result = EventsResponse.fromJson(response.data);
        // Clear first to ensure reactive update is triggered
        events.clear();
        events.addAll(result.data);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshEvents() async {
    await getEvents();
  }

  // Delete event
  Future<void> deleteEvent(String id, BuildContext context) async {
    try {
      isLoading.value = true;
      final response = await _userDataRepository.deleteEvent(id: id);
      ApiChecker.checkApi(response);
      if (response.statusCode == 200) {
        Helpers.showErrorSnackbar('Event deleted successfully');
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        events.removeWhere((element) => element.id == id);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Post event
  Future<void> postEvent({
    required String title,
    required String date,
    required String time,
    required int durationHours,
    required String eventType,
    required String location,
    required String notes,
    required PersonnelRequestModel personnel,
  }) async {
    final event = CreateEventRequestModel(
      title: title,
      date: date,
      time: time,
      durationHours: durationHours,
      eventType: eventType,
      location: location,
      notes: notes,
      personnel: personnel,
    );

    try {
      isLoading.value = true;
      final response = await _userDataRepository.createEvent(event);
      ApiChecker.checkApi(response);
      if (response.statusCode == 200) {
        // Show success message
        Helpers.showErrorSnackbar('Event created successfully');

        // Refresh the events list immediately to update UI
        await getEvents();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Update event
  Future<void> updateEvent({
    required String id,
    required String title,
    required String date,
    required String time,
    required int durationHours,
    required String eventType,
    required String location,
    required String notes,
    required PersonnelRequestModel personnel,
  }) async {
    final event = CreateEventRequestModel(
      title: title,
      date: date,
      time: time,
      durationHours: durationHours,
      eventType: eventType,
      location: location,
      notes: notes,
      personnel: personnel,
    );
    try {
      isLoading.value = true;
      final response = await _userDataRepository.patchEvent(
        id: id,
        model: event,
      );
      ApiChecker.checkApi(response);
      if (response.statusCode == 200) {
        await getEvents();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Get event detail by id
  Future<void> getEventDetailById({required String id}) async {
    try {
      isLoading.value = true;
      final response = await _userDataRepository.getEventDetailById(id: id);
      ApiChecker.checkApi(response);
      if (response.statusCode == 200) {
        final event = EventDetailsResponse.fromJson(response.data);
        eventDetails.value = event.data;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
