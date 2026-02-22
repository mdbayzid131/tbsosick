class CreateEventRequestModel {
  final String title;
  final String date; // yyyy-MM-dd
  final String time;
  final int durationHours;
  final String eventType;
  final String location;
  final String notes;
  final PersonnelRequestModel personnel;

  final String? linkPreferenceCardId;

  CreateEventRequestModel({
    required this.title,
    required this.date,
    required this.time,
    required this.durationHours,
    required this.eventType,
    required this.location,
    required this.notes,
    required this.personnel,
    this.linkPreferenceCardId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "title": title,
      "date": date,
      "time": time,
      "durationHours": durationHours,
      "eventType": eventType,
      "location": location,
      "notes": notes,
      "personnel": personnel.toJson(),
    };
    if (linkPreferenceCardId != null && linkPreferenceCardId!.isNotEmpty) {
      data["preferenceCard"] = linkPreferenceCardId;
    }
    return data;
  }
}

class PersonnelRequestModel {
  final String leadSurgeon;
  final List<String> surgicalTeam;

  PersonnelRequestModel({
    required this.leadSurgeon,
    required this.surgicalTeam,
  });

  Map<String, dynamic> toJson() {
    return {"leadSurgeon": leadSurgeon, "surgicalTeam": surgicalTeam};
  }
}
