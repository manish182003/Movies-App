import 'package:mmovies/widgets/GetMovies.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:isolate';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:mmovies/Models/Result.dart';
import 'package:mmovies/utils.dart';
import 'package:path_provider/path_provider.dart';

class DownloadMovie extends StatefulWidget {
  static const String routename = '/downloadmovie';
  Result data;
  DownloadMovie({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<DownloadMovie> createState() => _DownloadMovieState();
}

class _DownloadMovieState extends State<DownloadMovie> {
  int downloadprogress = 0;
  String filepath = '';
  bool isdownload = false;
  var taskid;
  String url = '';
  var newtaskid;
  bool isPermission = false;
  @override
  void initState() {
    super.initState();
    getPermission();
    getfileDirectory();
    geturl();
    if (!kIsWeb) {
      ReceivePort receivePort = ReceivePort();
      IsolateNameServer.registerPortWithName(receivePort.sendPort, 'games');
      receivePort.listen((dynamic message) {
        downloadprogress = message[2];
        print('my progress is:$downloadprogress');
        int status = message[1];

        taskid = message[0];
        print(message[0]);
        if (status == 3) {
          showsnackbar(context, 'Download Completed');
          setState(() {
            isdownload = false;
          });
        } else if (status == 6) {
          showsnackbar(context, 'Download Paused');
        } else if (status == 5) {
          setState(() {
            downloadprogress = 0;
          });
          showsnackbar(context, 'Download Cancelled');
        }
        setState(() {});

        //  print(message);
      });

      registercallback();
    }
  }

  void registercallback() {
    FlutterDownloader.registerCallback(downloadcallback);
  }

  getPermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted == true) {
      isPermission = true;
    } else {
      isPermission = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    IsolateNameServer.removePortNameMapping('games');
    FlutterDownloader.remove(taskId: taskid);
    FlutterDownloader.cancelAll();
  }

  @pragma('vm:entry-point')
  static downloadcallback(id, status, progress) {
    print(progress);

    SendPort sendPort = IsolateNameServer.lookupPortByName('games') as SendPort;
    // print(sendPort.toString());
    sendPort.send([id, status, progress]);
  }

  Future<void> geturl() async {
    url = GetUrl(context, widget.data);
  }

  Future<void> getfileDirectory() async {
    final appdir = await getExternalStorageDirectory();
    filepath = appdir!.path;
    print(filepath);
  }

  Future<void> startDownload(String url) async {
    taskid = await FlutterDownloader.enqueue(
      url: url,
      savedDir: filepath,
      fileName: '${widget.data.originalTitle}.mp4',
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          title: Text(
            'Download',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.76,
                  margin: EdgeInsets.only(
                    top: 10,
                    left: 10,
                  ),
                  child: Text(
                    widget.data.originalTitle,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  height: 10,
                  width: size.width * 0.76,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      value: downloadprogress.toDouble() * 0.01,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    isdownload
                        ? '${downloadprogress.toDouble()}% Downloaded'
                        : 'Download Not Started Yet',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        if (!isPermission) {
                          startDownload(url);
                          showsnackbar(context, 'Download Started');
                          setState(() {
                            isdownload = true;
                          });
                     
                           
                        } else {
                          showsnackbar(context, 'Access Denied');
                        }
                      },
                      child: Container(
                        width: 60,
                        height: 40,
                        margin:
                            EdgeInsets.only(left: 20, right: size.width * 0.08),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.download_rounded,
                          size: 35,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (taskid != null) {
                          if (isdownload) {
                            FlutterDownloader.pause(taskId: taskid);
                            setState(() {
                              isdownload = false;
                            });
                          } else {
                            FlutterDownloader.resume(taskId: taskid);
                            showsnackbar(context, 'Download Resumed');
                            setState(() {
                              isdownload = true;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: 60,
                        height: 40,
                        margin: EdgeInsets.only(right: size.width * 0.08),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isdownload ? Icons.pause : Icons.play_arrow,
                          size: 35,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (taskid != null) {
                          if (isdownload) {
                            FlutterDownloader.cancel(taskId: taskid);
                            setState(() {
                              isdownload = false;
                            });
                          } else {
                            showsnackbar(
                                context, 'Download Cannot be Cancel Now');
                          }
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 90,
              width: 65,
              margin: EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500/${widget.data.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ));
  }
}
