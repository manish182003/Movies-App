import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/constant.dart';
import 'package:mmovies/utils.dart';

class ComedyServices {
  Future<List<Result>> fetchtypeMovies(BuildContext context,int type) async {
    List<Result> typemovie = [];
    try {
      var res = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/discover/movie?api_key=$apikey&with_genres=$type'));
      if (res.statusCode == 200) {
        var result = json.decode(res.body)['results'];
        for (var i in result) {
          typemovie.add(Result.fromJson(i));
        }
     
      }
    } catch (e) {
      showsnackbar(context, e.toString());
    }
    return typemovie;
  }
}
