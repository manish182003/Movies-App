import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mmovies/movie_landing_screen.dart';
import 'package:mmovies/router.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
   FlutterDownloader.initialize(
    debug: true
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  // final channel = IOWebSocketChannel.connect('ws://192.168.87.10:3000');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF23272E),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateroute(settings),
      home: MovieLandingScreen(),
    );
  }
}
