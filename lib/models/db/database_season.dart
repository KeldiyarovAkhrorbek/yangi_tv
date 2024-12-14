import 'dart:ui';

class DatabaseSeason {
  String movie_name;
  String season_name;
  String image;

  DatabaseSeason({
    required this.movie_name,
    required this.season_name,
    required this.image,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatabaseSeason &&
          runtimeType == other.runtimeType &&
          movie_name == other.movie_name &&
          image == other.image &&
          season_name == other.season_name;
}
