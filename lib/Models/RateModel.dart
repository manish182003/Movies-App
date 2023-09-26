import 'dart:convert';

import 'package:mmovies/Models/Result.dart';

class Ratemodel {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  Ratemodel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  

 

 

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'results': results.map((x) => x.toJson()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }

  factory Ratemodel.fromMap(Map<String, dynamic> map) {
    return Ratemodel(
      page: map['page']?.toInt() ?? 0,
      results:  (map['results'] != null)
        ? List<Result>.from(map['results']!.map((x) => Result.fromJson(x)))
        : [],
      totalPages: map['total_pages']?.toInt() ?? 0,
      totalResults: map['total_results']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ratemodel.fromJson(String source) => Ratemodel.fromMap(json.decode(source));
}
