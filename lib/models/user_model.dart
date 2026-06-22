class UserModel {
  final String id;
  String role;
  final String fullName;
  final String mobileNo;
  final String email;
  final String city;
  final String fcmToken;

  UserModel({
    required this.id,
    required this.role,
    required this.fullName,
    required this.mobileNo,
    required this.email,
    required this.city,
    required this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      fullName: json['fullname'] ?? '',
      mobileNo: json['Mobileno'] ?? '',
      email: json['email'] ?? '',
      city: json['city'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'fullname': fullName,
      'Mobileno': mobileNo,
      'email': email,
      'city': city,
      'fcmToken': fcmToken,
    };
  }
}
