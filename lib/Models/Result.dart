class Result {
  bool adult;
  bool video;
  String backdropPath;
  List<int> genre_ids;
  int id;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  String title;
  double voteAverage;
  int voteCount;

  Result({
    required this.adult,
    required this.backdropPath,
    required this.genre_ids,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    this.video=false,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        adult: json["adult"] ?? false,
         video: json["video"] ?? false,
        backdropPath: json["backdrop_path"] ?? '',
        genre_ids: List<int>.from(json['genre_ids'] ?? []),
        originalTitle: json["original_title"] ?? '',
        overview: json["overview"] ?? '',
        popularity: json["popularity"]?.toDouble() ?? 0.0,
        posterPath: json["poster_path"] ?? '',
        releaseDate: json['release_date'] ?? '',
        title: json["title"] ?? '',
        voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
        id: json['id'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "video":video,
        "backdrop_path": backdropPath,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        'id': id,
      };
}
