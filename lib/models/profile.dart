class Profile {
  int id;
  String? name;
  String photo;
  String login;
  String tariff;
  String? expireTariff;
  double balance;

  Profile({
    required this.id,
    required this.name,
    required this.photo,
    required this.login,
    required this.tariff,
    required this.expireTariff,
    required this.balance,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      login: json['login'],
      tariff: json['tariff'],
      expireTariff: json['expire_tariff'],
      balance: (json['balance'] as num).toDouble(),
    );
  }
}
