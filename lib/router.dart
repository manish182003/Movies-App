import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/allTypeMovies.dart';
import 'package:mmovies/movie_landing_screen.dart';
import 'package:mmovies/screens/Download_movies.dart';
import 'package:mmovies/screens/all_movies.dart';
import 'package:mmovies/screens/alltypemovies.dart';
import 'package:mmovies/screens/movie_details.dart';
import 'package:mmovies/screens/search_result.dart';
import 'package:mmovies/screens/search_screen.dart';
import 'package:mmovies/widgets/searchresultargument.dart';

Route<dynamic> generateroute(RouteSettings settings) {
  switch (settings.name) {
    case AllMovies.routename:
      var title = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => AllMovies(title: title),
      );
    case MovieDetails.routename:
      var data = settings.arguments as Result;
      return MaterialPageRoute(
        builder: (context) => MovieDetails(data: data),
      );
    case MovieLandingScreen.routename:
      return MaterialPageRoute(
        builder: (context) => MovieLandingScreen(),
      );
      case DownloadMovie.routename:
      var movie=settings.arguments as Result;
      return MaterialPageRoute(
        builder: (context) => DownloadMovie(data: movie),
      );
    case TypeMovies.routename:
      var arg = settings.arguments as AllTypeMovies;
      return MaterialPageRoute(
        builder: (context) => TypeMovies(
          title: arg.title,
          genre: arg.genre,
        ),
      );
    case SearchResult.routename:
      var arg = settings.arguments as searchresultargument;
      return MaterialPageRoute(
          builder: (context) => SearchResult(
                data: arg.data,
                query: arg.query,
              ));
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('Page does not Exists'),
          ),
        ),
      );
  }
}
