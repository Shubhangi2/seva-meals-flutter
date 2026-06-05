class UserModel {
  final String role;
  final String fullName;
  final int mobileNo;

  UserModel({required this.role, required this.fullName, required this.mobileNo});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      role: json['role'] ?? '',
      fullName: json['Fullname'] ?? '',
      mobileNo: int.parse(json['Mobileno'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {'role': role, 'Fullname': fullName, 'Mobileno': mobileNo};
  }
}
