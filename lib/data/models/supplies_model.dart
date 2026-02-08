class SuppliesResponse {
  final bool success;
  final int statusCode;
  final List<SuppliesModel> supplies;

  SuppliesResponse({
    required this.success,
    required this.statusCode,
    required this.supplies,
  });

  factory SuppliesResponse.fromJson(Map<String, dynamic> json) {
    // Check multiple potential locations for the list
    var listData = json['supplies'] ?? json['data'];

    // If it's still null or not a list, it might be an empty response
    List<dynamic> list = [];
    if (listData is List) {
      list = listData;
    } else if (listData is Map && listData['supplies'] is List) {
      list = listData['supplies'];
    }

    return SuppliesResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      supplies: list
          .map((e) => SuppliesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'supplies': supplies.map((e) => e.toJson()).toList(),
    };
  }
}

class SuppliesModel {
  final String id;
  final String name;

  SuppliesModel({required this.id, required this.name});

  factory SuppliesModel.fromJson(Map<String, dynamic> json) {
    return SuppliesModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
