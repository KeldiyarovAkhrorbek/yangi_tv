class Tariff {
  int id;
  String name;
  int cost;
  String description;

  Tariff({
    required this.id,
    required this.name,
    required this.cost,
    required this.description,
  });

  factory Tariff.fromJson(Map<String, dynamic> json) {
    return Tariff(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
      description: json['description'],
    );
  }
}
