class MovieShort {
  final int id;
  final String name;
  final String tariff;
  final String poster;

  MovieShort({
    required this.id,
    required this.name,
    required this.tariff,
    required this.poster,
  });

  factory MovieShort.fromJson(Map<String, dynamic> json) {
    return MovieShort(
      id: json['id'] ?? json['content_id'],
      name: json['name'],
      tariff: json['tariff'],
      poster: json['poster'] ?? json['image'],
    );
  }
}
