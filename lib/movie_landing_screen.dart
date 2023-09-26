import 'package:flutter/material.dart';
import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/TypeServices/type%20services.dart';
import 'package:mmovies/allTypeMovies.dart';
import 'package:mmovies/screens/all_movies.dart';
import 'package:mmovies/screens/alltypemovies.dart';
import 'package:mmovies/screens/search_screen.dart';
import 'package:dio/dio.dart';
import 'package:mmovies/services/Movie_Services.dart';
import 'package:mmovies/widgets/comedymovie.dart';
import 'package:mmovies/widgets/popularmovies.dart';

class MovieLandingScreen extends StatefulWidget {
  static const String routename = '/movie-landing';
  const MovieLandingScreen({super.key});

  @override
  State<MovieLandingScreen> createState() => _MovieLandingScreenState();
}

class _MovieLandingScreenState extends State<MovieLandingScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Dio dio = Dio();
    double? progress;
    MovieServices services = MovieServices();
    List<Result> result = [];
    List<dynamic> searchedmovie = [];
    final comedyServices = ComedyServices();
    bool isloading = true;

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

    void fetchdata() {}

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/movie.png',
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'mMovies',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          centerTitle: true,
          leading: Container(
            margin: EdgeInsets.only(left: 8, top: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.black26,
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 15, top: 5),
              child: CircleAvatar(
                child: Image.asset('assets/person1.png'),
                radius: 25,
              ),
            )
          ],
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              SearchScreen(),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Popular Movies',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AllMovies.routename,
                          arguments: 'Trending Movies',
                        );
                      },
                      child: Text(
                        'View all',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 300,
                width: double.infinity,
                child: PopularMovies(),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Comedy Movies',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          TypeMovies.routename,
                          arguments: AllTypeMovies(
                            title: 'Comedy Movies',
                            genre: 35,
                          ),
                        );
                      },
                      child: Text(
                        'View all',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 300,
                width: double.infinity,
                child: ComedyMovie(),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
