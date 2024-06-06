class Genre {
  final int id;
  final String name;
  final String? image;

  Genre({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
