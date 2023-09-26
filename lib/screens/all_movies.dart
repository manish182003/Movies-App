import 'package:flutter/material.dart';
import 'package:mmovies/Models/RateModel.dart';
import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/screens/movie_details.dart';
import 'package:mmovies/services/Movie_Services.dart';
import 'package:mmovies/widgets/movie.dart';

class AllMovies extends StatefulWidget {
  static const String routename = '/all-movies';
  final String title;

  AllMovies({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<AllMovies> createState() => _AllMoviesState();
}

class _AllMoviesState extends State<AllMovies> {
  final MovieServices services = MovieServices();
  final List<Result> result = [];
  int? crossaxiscount;
  Ratemodel? ratemodel;
  List<List<Result>> res = [];

  @override
  void initState() {
    super.initState();
    crossaxiscount = 2;
    fetchmovies();
  }

  Future<void> fetchmovies() async {
    ratemodel = await services.getdata(context);

    for (int i = 1; i < 12; i++) {
      List<Result> movies = await services.PopularMovies(context, i);
      result.addAll(movies);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

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
                    crossAxisCount: crossaxiscount!,
                      childAspectRatio: 0.7,
                  ),
                ),
        ));
  }
}
