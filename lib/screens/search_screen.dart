import 'package:flutter/material.dart';
import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/movie_landing_screen.dart';
import 'package:mmovies/screens/search_result.dart';
import 'package:mmovies/services/Movie_Services.dart';
import 'package:mmovies/widgets/searchresultargument.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  MovieServices services = MovieServices();
  List<Result> result = [];
  List<Result> searchedmovie = [];

  Future<void> fetch() async {
    for (int i = 1; i < 12; i++) {
      List<Result> movies = await services.PopularMovies(context, i);
      result.addAll(movies);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void searchquery(String query) {
    setState(() {
      searchedmovie = result
          .where((movie) => movie.originalTitle
              .toString()
              .toLowerCase()
              .contains(query.toString()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    MovieLandingScreen movieLandingScreen = MovieLandingScreen();
    return Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          style: TextStyle(
            fontSize: 18,
          ),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.all(20),
            fillColor: Colors.grey.withOpacity(0.53),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 30,
              color: Colors.yellow,
            ),
            hintText: 'Search',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.mic,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          onSubmitted: (value) {
            searchquery(value);
            setState(() {});
            Navigator.pushNamed(context, SearchResult.routename,
                arguments:
                    searchresultargument(data: searchedmovie, query: value));
            setState(() {});
          },
        ));
  }
}
