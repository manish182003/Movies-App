import 'package:flutter/material.dart';

import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/screens/movie_details.dart';
import 'package:mmovies/services/Movie_Services.dart';
import 'package:mmovies/widgets/movie.dart';

class TypeMovies extends StatefulWidget {
  static const String routename = '/typemovie';
  String title;
  int genre;
  TypeMovies({
    Key? key,
    required this.title,
    required this.genre,
  }) : super(key: key);

  @override
  State<TypeMovies> createState() => _TypeMoviesState();
}

class _TypeMoviesState extends State<TypeMovies> {
  MovieServices services = MovieServices();
  List<Result> result = [];
  int? crossaxiscount;

  @override
  void initState() {
    super.initState();
    fetchmovies();
  }

  Future<void> fetchmovies() async {
    for (int i = 1; i < 12; i++) {
      List<Result> movies = await services.TypeMovies(context, i, widget.genre);
      result.addAll(movies);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: result.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  final data = result[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      crossaxiscount = constraints.maxWidth > 600 ? 4 : 2;

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, MovieDetails.routename,
                              arguments: data);
                        },
                        child: Movietrending(data: data),
                      );
                    },
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
              ),
      ),
    );
  }
}
