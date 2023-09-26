import 'package:flutter/material.dart';
import 'package:mmovies/Models/RateModel.dart';
import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/screens/movie_details.dart';
import 'package:mmovies/services/Movie_Services.dart';

class PopularMovies extends StatefulWidget {
  const PopularMovies({super.key});

  @override
  State<PopularMovies> createState() => _PopularMoviesState();
}

class _PopularMoviesState extends State<PopularMovies> {
  final MovieServices services = MovieServices();
  Ratemodel? rate;
  List<Result> result = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    popularmovies();
  }

  void popularmovies() async {
    int page = 1;
    List<Result> results = await services.PopularMovies(context, page);
    if (result.isEmpty) {
      setState(() {
        result = results;
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: result.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              var data = result[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, MovieDetails.routename,
                      arguments: data);
                },
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 230,
                      margin: EdgeInsets.only(
                        left: 30, // Remove left margin for the first element
                        top: 10,
                        right: 20,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500/${data.posterPath}',
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(),
                      child: Text(
                        data.originalTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                        textScaleFactor: 0.7,
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              );
            },
          );
  }
}
