class ActiveTariff {
  int id;
  String name;
  String expire;

  ActiveTariff({
    required this.id,
    required this.name,
    required this.expire,
  });

  factory ActiveTariff.fromJson(Map<String, dynamic> json) {
    return ActiveTariff(
      id: json['id'],
      name: json['name'],
      expire: json['expire'],
    );
  }
}
