class OrderModel {
  final int id;
  final String name;
  final int? contentId;
  final String status;
  final String? message;

  OrderModel({
    required this.id,
    required this.name,
    this.contentId,
    required this.status,
    this.message,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      name: json['name'],
      contentId: json['content_id'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content_id': contentId,
      'status': status,
      'message': message,
    };
  }
}
