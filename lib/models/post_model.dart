class PostModel {
  String? postId;
  final String donorId;
  final String title;
  final String description;
  final String foodType;
  final String quantity;
  final String city;
  final String region;
  final String pickupAddress;
  final String? donationAddress;
  final String pickupFoodPictureUrl;
  final String? postDriveFoodPictureUrl;
  final String? volunteerId;
  final String status;
  final String createdAt;
  final String updatedAt;

  PostModel({
    this.postId,
    required this.donorId,
    required this.title,
    required this.description,
    required this.foodType,
    required this.quantity,
    required this.city,
    required this.region,
    required this.pickupAddress,
    this.donationAddress,
    required this.pickupFoodPictureUrl,
    this.postDriveFoodPictureUrl,
    this.volunteerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'] ?? '',
      donorId: json['donorId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      foodType: json['foodType'] ?? '',
      quantity: json['quantity'] ?? '',
      city: json['city'] ?? '',
      region: json['region'] ?? '',
      pickupAddress: json['pickupAddress'] ?? '',
      donationAddress: json['donationAddress'] ?? '',
      pickupFoodPictureUrl: json['pickupFoodPictureUrl'] ?? '',
      postDriveFoodPictureUrl: json['postDriveFoodPictureUrl'] ?? '',
      volunteerId: json['volunteerId'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'donorId': donorId,
      'title': title,
      'description': description,
      'foodType': foodType,
      'quantity': quantity,
      'city': city,
      'region': region,
      'pickupAddress': pickupAddress,
      'donationAddress': donationAddress,
      'pickupFoodPictureUrl': pickupFoodPictureUrl,
      'postDriveFoodPictureUrl': postDriveFoodPictureUrl,
      'volunteerId': volunteerId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
