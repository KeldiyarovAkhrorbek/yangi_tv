class PaymentHistory {
  final int id;
  final String system;
  final int amount;
  final String description;
  final String image;
  final String status;
  final String date;

  PaymentHistory({
    required this.id,
    required this.system,
    required this.amount,
    required this.description,
    required this.image,
    required this.status,
    required this.date,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'],
      system: json['system'],
      amount: json['amount'],
      description: json['description'],
      image: json['image'],
      status: json['status'],
      date: json['date'],
    );
  }
}
