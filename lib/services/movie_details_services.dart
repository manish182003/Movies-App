import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/Models/genre.dart';
import 'package:mmovies/Models/genreList.dart';
import 'package:mmovies/constant.dart';
import 'package:mmovies/utils.dart';
import 'package:http/http.dart' as http;

class MovieDetailsServices {
  Future<List<String>> fetchmovietrailer(
      BuildContext context, Result data) async {
    List<String> key = [];
    try {
      var response = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/movie/${data.id}/videos?api_key=$apikey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for (var video in data['results']) {
          key.add(video['key']);
        }
      }
    } catch (e) {
      showsnackbar(context, e.toString());
    }
    return key;
  }

  Future<List<String>> fetchmovietype(
      BuildContext context, List<int> id) async {
    List<String> type = [];
    try {
      var res = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/genre/movie/list?api_key=$apikey'));

      var get = jsonDecode(res.body)['genres'];
      GenreList genreList = GenreList.fromJson(get);

      for (var i = 0; i < genreList.genres.length; i++) {
        for (var j = 0; j < id.length; j++) {
          if (genreList.genres[i].id == id[j]) {
            type.add(genreList.genres[i].name);
          }
        }
      }
    } catch (e) {
      showsnackbar(context, e.toString());
    }
    return type;
  }

  Future<int?> fetchmovieduration(BuildContext context, int id) async {
    int? duration;
    try {
      var res = await http.get(
          Uri.parse('https://api.themoviedb.org/3/movie/$id?api_key=$apikey'));

      var response = jsonDecode(res.body)['runtime'];
      duration = response;
    } catch (e) {
      showsnackbar(context, e.toString());
    }
    return duration;
  }

  Future<String> fetchmoviecountry(BuildContext context, int id) async {
    String country = '';
    try {
      var res = await http.get(
          Uri.parse('https://api.themoviedb.org/3/movie/$id?api_key=$apikey'));

      country = jsonDecode(res.body)['production_countries'][0]['name'];
      fetchbudget(context, id);
    } catch (e) {
      showsnackbar(context, e.toString());
    }

    return country;
  }

  Future<int?> fetchbudget(BuildContext context, int id) async {
    int? budget;
    try {
      var res = await http.get(
          Uri.parse('https://api.themoviedb.org/3/movie/$id?api_key=$apikey'));

      budget = jsonDecode(res.body)['budget'];
      var a = budget! * 83.07;
      budget = (a / 10000000).toInt();
    } catch (e) {
      showsnackbar(context, e.toString());
    }
    return budget;
  }
}
