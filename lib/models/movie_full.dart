import 'genre.dart';

class MovieFull {
  int id;
  String tariff;
  String poster;
  List<String> qualities;
  String name;
  String? nameRu;
  String? origName;
  String? episodes;
  String? lang;
  int? year;
  List<Country> countries;
  dynamic trailer;
  String? youtubeTrailer;
  String? rating;
  String? duration;
  String? access_download;
  String? age;
  String? type;
  Reactions reactions;
  List<Genre> genres;
  List<Actor> director;
  List<Actor> actors;
  String? description;
  List<Screenshot>? screenshots;
  bool is_favorite;
  bool is_comments;
  int? voice_mode;

  MovieFull({
    required this.id,
    required this.tariff,
    required this.poster,
    required this.qualities,
    required this.name,
    required this.nameRu,
    required this.origName,
    required this.episodes,
    required this.lang,
    required this.year,
    required this.countries,
    required this.trailer,
    required this.youtubeTrailer,
    required this.rating,
    required this.duration,
    required this.age,
    required this.type,
    required this.reactions,
    required this.genres,
    required this.director,
    required this.actors,
    required this.description,
    required this.screenshots,
    required this.is_favorite,
    required this.is_comments,
    required this.voice_mode,
    required this.access_download,
  });

  factory MovieFull.fromJson(Map<String, dynamic> json) {
    return MovieFull(
      id: json['id'],
      tariff: json['tariff'],
      poster: json['poster'],
      qualities: List<String>.from(json['qualities']),
      name: json['name'],
      nameRu: json['name_ru'],
      origName: json['orig_name'],
      episodes: json['episodes'],
      lang: json['lang'],
      year: json['year'],
      countries:
          List<Country>.from(json['countries'].map((x) => Country.fromJson(x))),
      trailer: json['trailer'],
      youtubeTrailer: json['youtube_trailer'],
      access_download: json['access_download'],
      rating: json['rating'],
      duration: json['duration'],
      age: json['age'],
      type: json['type'],
      reactions: Reactions.fromJson(json['reactions']),
      genres: List<Genre>.from(json['genres'].map((x) => Genre.fromJson(x))),
      director:
          List<Actor>.from(json['director'].map((x) => Actor.fromJson(x))),
      actors: List<Actor>.from(json['actors'].map((x) => Actor.fromJson(x))),
      description: json['description'],
      is_favorite: json['is_favorite'],
      is_comments: json['is_comments'],
      voice_mode: json['voice_mode'],
      screenshots: List<Screenshot>.from(
          json['screenshots'].map((x) => Screenshot.fromJson(x))),
    );
  }
}

class Country {
  int id;
  String name;

  Country({
    required this.id,
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Reactions {
  dynamic type;
  int like;
  int dislike;

  Reactions({
    required this.type,
    required this.like,
    required this.dislike,
  });

  factory Reactions.fromJson(Map<String, dynamic> json) {
    return Reactions(
      type: json['type'],
      like: json['like'],
      dislike: json['dislike'],
    );
  }
}

class Actor {
  int id;
  String name;
  String image;

  Actor({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class Screenshot {
  int id;
  String image;

  Screenshot({
    required this.id,
    required this.image,
  });

  factory Screenshot.fromJson(Map<String, dynamic> json) {
    return Screenshot(
      id: json['id'],
      image: json['image'],
    );
  }
}
