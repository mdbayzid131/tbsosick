class UserModel {
  final String? id;
  final String? name;
  final String? role;
  final String? email;
  final String? country;
  final String? phone;
  final String? profilePicture;
  final String? status;
  final bool? verified;
  final List<String>? deviceTokens;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? specialty;
  final String? hospital;

  UserModel({
    this.id,
    this.name,
    this.role,
    this.email,
    this.country,
    this.phone,
    this.profilePicture,
    this.status,
    this.verified,
    this.deviceTokens,
    this.createdAt,
    this.updatedAt,
    this.specialty,
    this.hospital,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'], // backend uses _id
      name: json['name'],
      role: json['role'],
      email: json['email'],
      country: json['country'],
      phone: json['phone'],
      profilePicture: json['profilePicture'],
      status: json['status'],
      verified: json['verified'],
      specialty: json['specialty'],
      hospital: json['hospital'],
      deviceTokens: json['deviceTokens'] != null
          ? List<String>.from(json['deviceTokens'])
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'role': role,
      'email': email,
      'country': country,
      'phone': phone,
      'profilePicture': profilePicture,
      'status': status,
      'verified': verified,
      'deviceTokens': deviceTokens,
      'specialty': specialty,
      'hospital': hospital,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
