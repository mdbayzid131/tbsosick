class EventDetailsResponse {
  final bool success;
  final String message;
  final EventDetailsModel data;

  EventDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EventDetailsResponse.fromJson(Map<String, dynamic> json) {
    return EventDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: EventDetailsModel.fromJson(json['data']),
    );
  }
}
class EventDetailsModel {
  final String id;
  final String userId;
  final String title;
  final DateTime date;
  final String time;
  final int durationHours;
  final String eventType;
  final String location;
  final String? notes;
  final PersonnelModel? personnel;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventDetailsModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.time,
    required this.durationHours,
    required this.eventType,
    required this.location,
    this.notes,
    this.personnel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) {
    return EventDetailsModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      date: DateTime.parse(json['date']),
      time: json['time'] ?? '',
      durationHours: json['durationHours'] ?? 0,
      eventType: json['eventType'] ?? '',
      location: json['location'] ?? '',
      notes: json['notes'],
      personnel: json['personnel'] != null
          ? PersonnelModel.fromJson(json['personnel'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "title": title,
      "date": date.toIso8601String(),
      "time": time,
      "durationHours": durationHours,
      "eventType": eventType,
      "location": location,
      "notes": notes,
      "personnel": personnel?.toJson(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
class PersonnelModel {
  final String leadSurgeon;
  final List<String> surgicalTeam;

  PersonnelModel({
    required this.leadSurgeon,
    required this.surgicalTeam,
  });

  factory PersonnelModel.fromJson(Map<String, dynamic> json) {
    return PersonnelModel(
      leadSurgeon: json['leadSurgeon'] ?? '',
      surgicalTeam: List<String>.from(json['surgicalTeam'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "leadSurgeon": leadSurgeon,
      "surgicalTeam": surgicalTeam,
    };
  }
}
