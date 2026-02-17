class CreateEventRequestModel {
  final String title;
  final String date; // yyyy-MM-dd
  final String time;
  final int durationHours;
  final String eventType;
  final String location;
  final String notes;
  final PersonnelRequestModel personnel;

  CreateEventRequestModel({
    required this.title,
    required this.date,
    required this.time,
    required this.durationHours,
    required this.eventType,
    required this.location,
    required this.notes,
    required this.personnel,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "date": date,
      "time": time,
      "durationHours": durationHours,
      "eventType": eventType,
      "location": location,
      "notes": notes,
      "personnel": personnel.toJson(),
    };
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
    return {
      "leadSurgeon": leadSurgeon,
      "surgicalTeam": surgicalTeam,
    };
  }
}
