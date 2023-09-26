import 'package:flutter/material.dart';

import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/screens/movie_details.dart';
import 'package:mmovies/services/Movie_Services.dart';
import 'package:mmovies/widgets/searchresultargument.dart';

class SearchResult extends StatefulWidget {
  List<Result> data;
  String query;
  static const String routename = '/search';

  SearchResult({
    Key? key,
    required this.data,
    required this.query,
  }) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  bool show = false;
  List<Result> result = [];
  List<Result> searchedmovie = [];

  Future<void> fetch() async {
    MovieServices services = MovieServices();
    for (int i = 1; i < 12; i++) {
      List<Result> movies = await services.PopularMovies(context, i);
      result.addAll(movies);
    }
    setState(() {});
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
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffebecee),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(show ? 150 : 70),
        child: AppBar(
          backgroundColor: Colors.white,
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
                  color: Colors.black,
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
            child: Container(
              child: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20, top: 10),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: show ? Colors.grey.shade600 : Colors.grey.shade200,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: show ? Colors.white : Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    show = !show;
                  });
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Visibility(
              visible: show,
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.93,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(3)),
                margin: EdgeInsets.only(bottom: 25),
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 5,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.only(top: 15, left: 12),
                    hintText: 'Search..',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.deepOrangeAccent,
                      ),
                      onPressed: () {},
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  onSubmitted: (value) {
                    searchquery(value);
                    setState(() {});
                    Navigator.pushNamed(context, SearchResult.routename,
                        arguments: searchresultargument(
                            data: searchedmovie, query: value));
                    setState(() {});
                  },
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: Visibility(
              visible: widget.data.isEmpty ? false : true,
              child: Text(
                'Search results for "${widget.query}"',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          widget.data.isEmpty
              ? Container(
                  margin: EdgeInsets.only(top: 200),
                  child: Center(
                    child: Text(
                      'No Result Found',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: widget.data.length,
                    itemBuilder: (context, index) {
                      var movie = widget.data[index];
                      var releasedate = movie.releaseDate;
                      var year = DateTime.parse(releasedate).year.toString;
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, MovieDetails.routename,
                              arguments: movie);
                        },
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                //  width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                    fit: BoxFit.cover,
                                    // height: screenHeight*0.55,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(12),
                                // width: double.infinity,
                                alignment: Alignment.center,
                                //   height: screenHeight*0.12,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  color: Colors.yellow,
                                ),
                                child: Text(
                                  movie.originalTitle,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
