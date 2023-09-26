import 'package:flutter/material.dart';
import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/TypeServices/type%20services.dart';
import 'package:mmovies/screens/movie_details.dart';

class ComedyMovie extends StatefulWidget {
  const ComedyMovie({super.key});

  @override
  State<ComedyMovie> createState() => _ComedyMovieState();
}

class _ComedyMovieState extends State<ComedyMovie> {
  bool isloading = true;
  List<Result> result = [];
  final comedymovie = ComedyServices();

  @override
  void initState() {
    super.initState();
    fetchcomedymovies();
  }

  Future<void> fetchcomedymovies() async {
    result = await comedymovie.fetchtypeMovies(context,35);
    setState(() {
      isloading = false;
    });
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
