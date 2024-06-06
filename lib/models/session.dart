class SessionModel {
  String? name;
  String? deviceModel;
  String token;
  String? createdAt;

  SessionModel({
    required this.name,
    required this.deviceModel,
    required this.token,
    required this.createdAt,
  });

  factory SessionModel.fromJson(dynamic json) {
    return SessionModel(
      name: json['name'] ?? json['device_name'],
      deviceModel: json['device_model'],
      token: json['token'] ?? json['device_token'],
      createdAt: json['created_at'],
    );
  }
}
