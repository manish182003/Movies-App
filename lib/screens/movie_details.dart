import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/TypeServices/type%20services.dart';
import 'package:mmovies/screens/Download_movies.dart';
import 'package:mmovies/screens/search_result.dart';
import 'package:mmovies/services/Movie_Services.dart';

import 'package:mmovies/services/movie_details_services.dart';
import 'package:mmovies/widgets/popularmovies.dart';
import 'package:mmovies/widgets/searchresultargument.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

class MovieDetails extends StatefulWidget {
  static const String routename = '/movie-details';
  final Result data;
  const MovieDetails({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> keys = [];
  List<String> type = [];
  String country = '';

  int? budget;
  int? duration;
  MovieDetailsServices services = MovieDetailsServices();
  late YoutubePlayerController youtubePlayerController =
      YoutubePlayerController(initialVideoId: '');

  bool isvideoloaded = false;
  bool show = false;
  bool iszero = false;
  List<Result> result = [];
  bool isloading = true;
  List<Result> searchedmovie = [];
  final comedymovie = ComedyServices();

  Future<List<String>> fetchmovieskey() async {
    keys = await services.fetchmovietrailer(context, widget.data);
    return keys;
  }

  @override
  void dispose() {
    youtubePlayerController.dispose();

    super.dispose();
  }

  Future<void> fetch() async {
    MovieServices services = MovieServices();
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
    fetchmovietype();
    fetchmoviedetails();
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

  Future<void> fetchmovietype() async {
    type = await services.fetchmovietype(context, widget.data.genre_ids);
    setState(() {});
  }

  Future<void> fetchmoviedetails() async {
    duration = await services.fetchmovieduration(context, widget.data.id);
    setState(() {});
    country = await services.fetchmoviecountry(context, widget.data.id);
    setState(() {});
    budget = await services.fetchbudget(context, widget.data.id);
    if (budget == 0) {
      iszero = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var releasedate = widget.data.releaseDate;
    var size;
    DateTime parsetime = DateTime.parse(releasedate);
    var year = parsetime.year.toString();
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
                          color: Colors.transparent,
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
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black45,
                        ),
                      )),
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
      body: country.isEmpty || budget == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Color(0xffebecee),
              margin: EdgeInsets.only(top: 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12),
                      height: 90,
                      width: width * 0.98,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Container(
                        // margin: EdgeInsets.only(
                        //   left: 50,
                        //   top: 20,
                        //   right: 25,
                        // ),
                        child: Text(
                          'Download Any Movie Free of Cost Only (Hollywood Movies Available)',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500/${widget.data.posterPath}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: width * 0.95,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 12,
                              left: 12,
                              bottom: 0,
                              right: 20,
                            ),
                            child: Text(
                              '${widget.data.originalTitle} (${year})',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(12),
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.video_call,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Trailer',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              onPressed: () {
                                YYDialog().build(context)
                                  ..gravity = Gravity.center
                                  ..borderRadius = 12
                                  // ..width = double.infinity
                                  // ..margin=EdgeInsets.all(20)
                                  ..widget(
                                    OrientationBuilder(
                                      builder: (context, orientation) {
                                        return Container(
                                          width: width * 0.9,
                                          height: height * 0.3,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '${widget.data.originalTitle}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    // padding: EdgeInsets.only(
                                                    //   bottom: 20,
                                                    //   left: 10,
                                                    // ),
                                                    icon: Icon(
                                                      Icons.cancel,
                                                      color: Colors.grey,
                                                      size: 30,
                                                    ),
                                                    onPressed: () {
                                                      SystemChrome
                                                          .setPreferredOrientations([
                                                        DeviceOrientation
                                                            .portraitUp,
                                                        DeviceOrientation
                                                            .portraitDown,
                                                      ]);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                // height: height * 0.4,
                                                // width: double.infinity,
                                                child: MovieTailer(),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  ..show();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              widget.data.overview,
                              style: TextStyle(color: Colors.grey.shade600),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        'Genre: ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      for (var i in type)
                                        Container(
                                          child: Text(
                                            '$i  ',
                                            style: TextStyle(
                                              color: Colors.deepOrange,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Country: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      country,
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Duration: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '$duration min',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Budget: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    iszero
                                        ? Text(
                                            'Budget Yet Not Known',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          )
                                        : Text(
                                            '$budget crore (INR)',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Release: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      year,
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'TMDB: ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 0),
                                      alignment: Alignment.center,
                                      width: 35,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        widget.data.voteAverage.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          DownloadMovie.routename,
                          arguments: widget.data,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 12),
                        height: 55,
                        width: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Download',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: width * 0.2,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Server',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 50,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: width * 0.25,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Language',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 50,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: width * 0.2,
                            child: Container(
                              margin: EdgeInsets.only(top: 3),
                              alignment: Alignment.center,
                              child: Text(
                                'Adult',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 50,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: width * 0.2,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Links',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: width * 0.2,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/world.png',
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 50,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              width: width * 0.25,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/flag.jpg',
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 50,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              width: width * 0.2,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.data.adult.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 50,
                              color: Colors.black12,
                            ),
                            Expanded(
                              //   width: width*0.252,
                              // color: Colors.orange,

                              child: Container(
                                // width: double.infinity,

                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.download,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      DownloadMovie.routename,
                                      arguments: widget.data,
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  FutureBuilder<List<String>> MovieTailer() {
    return FutureBuilder<List<String>>(
      future: fetchmovieskey(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final data = snapshot.data;
          if (data!.isEmpty) {
            return const Center(
              child: Text('No Tailer available'),
            );
          }
          youtubePlayerController = YoutubePlayerController(
            initialVideoId: data[0],
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              enableCaption: true,
              forceHD: true,
              loop: true,
              captionLanguage: 'English',
              controlsVisibleAtStart: false,
              //   showLiveFullscreenButton: false,
              // useHybridComposition: true,
            ),
          )..cue(data[0]);

          return ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: YoutubePlayer(
              controller: youtubePlayerController,
              onEnded: (metaData) {
                metaData.title;
              },
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              progressColors: const ProgressBarColors(
                playedColor: Colors.blue,
                handleColor: Colors.blueAccent,
              ),
              thumbnail: Image.network(
                'https://image.tmdb.org/t/p/w500/${widget.data.backdropPath}',
                fit: BoxFit.cover,
              ),
            ),
          );
        }
      },
    );
  }
}
