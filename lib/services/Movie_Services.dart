import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mmovies/Models/RateModel.dart';
import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/constant.dart';
import 'package:mmovies/utils.dart';

class MovieServices {
  Future<List<Result>> PopularMovies(BuildContext context, int page) async {
    List<Result> result = [];
    Ratemodel? ratemodel;
    var a;
    try {
      var res = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=$apikey&page=$page',
        ),
      );

      if (res.statusCode == 200) {
        a = json.decode(res.body);
        ratemodel = Ratemodel.fromMap(a);
        if (ratemodel.results.isNotEmpty) {
          result = ratemodel.results;
        }
      }
    } catch (e) {
      showsnackbar(context, e.toString());
    }

    return result;
  }

  Future<Ratemodel?> getdata(BuildContext context) async {
    Ratemodel? ratemodel;
    var a;
    try {
      var res = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=$apikey',
        ),
      );

      if (res.statusCode == 200) {
        a = json.decode(res.body);
        ratemodel = Ratemodel.fromMap(a);
      }
    } catch (e) {
      showsnackbar(context, e.toString());
    }
    return ratemodel;
  }

  Future<List<Result>> TypeMovies(
      BuildContext context, int page, int type) async {
    List<Result> result = [];
    Ratemodel? ratemodel;
    var a;
    try {
      var res = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=$apikey&with_genres=$type&page=$page',
        ),
      );

      if (res.statusCode == 200) {
        a = json.decode(res.body);
        ratemodel = Ratemodel.fromMap(a);
        if (ratemodel.results.isNotEmpty) {
          result = ratemodel.results;
       
        }
      }
    } catch (e) {
      showsnackbar(context, e.toString());
    }

    return result;
  }
}
