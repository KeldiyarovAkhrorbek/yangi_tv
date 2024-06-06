import 'package:yangi_tv_new/models/genre.dart';

class Search {
  final int id;
  final String name;
  final int year;
  final String age;
  final String poster;
  final List<Genre> genres;
  final String tariff;

  Search({
    required this.id,
    required this.name,
    required this.year,
    required this.age,
    required this.poster,
    required this.genres,
    required this.tariff,
  });

  String genresText() {
    String result = '';
    genres.forEach((element) {
      result += element.name + ', ';
    });
    if (result.length > 0) {
      result = result.substring(0, result.length - 1);
    }
    if (result.length > 0) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }

  factory Search.fromJson(Map<String, dynamic> json) {
    List<Genre> genresList = [];
    if (json['genres'] != null) {
      genresList = List<Genre>.from(
          json['genres'].map((genre) => Genre.fromJson(genre)));
    }
    return Search(
      id: json['id'],
      name: json['name'],
      year: json['year'],
      age: json['age'],
      poster: json['poster'],
      genres: genresList,
      tariff: json['tariff'],
    );
  }
}
