import 'package:mmovies/Models/genre.dart';

class GenreList {
  final List<Genre> genres;

  GenreList({required this.genres});

  factory GenreList.fromJson(List<dynamic>? json) {
    List<Genre> genreList = json?.map((genreJson) => Genre.fromJson(genreJson)).toList() ?? [];
    return GenreList(genres: genreList);
  }
}
