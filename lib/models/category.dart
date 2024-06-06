import 'Movie_Short.dart';

class Category {
  int id;
  String name;
  List<MovieShort> movies;

  Category({required this.id, required this.name, required this.movies});
}