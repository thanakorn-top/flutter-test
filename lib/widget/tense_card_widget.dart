import 'dart:async';
import 'dart:io';

import 'package:engbooster/widget/textspan_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:audioplayer/audioplayer.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class TenseCardWidget extends StatefulWidget {
  final PageController pageController;
  final bool firstCard;
  final Map map;
  final Function func;

  final bool lastCard;

  TenseCardWidget(
      {this.pageController,
      this.firstCard = false,
      this.lastCard = false,
      this.map,
      this.func});

  @override
  _TenseCardWidgetState createState() => _TenseCardWidgetState();
}

class _TenseCardWidgetState extends State<TenseCardWidget>
    with TickerProviderStateMixin {
  Future<String> downloadURL(String path) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(path)
        .getDownloadURL();
    return downloadURL;
  }

  AudioPlayer audioPlayer = AudioPlayer();
  bool playing = false;
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  PlayerState playerState = PlayerState.stopped;
  Duration duration;
  Duration position;
  List<Widget> exampleList =[];

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    setExample();
    // playByText(widget.map["vocab"]);
  }

  void play(String url) {
    audioPlayer.play(url);
    setState(() {
      playing = true;
    });
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  Future<dynamic> playByText(String text) async {
    setState(() {
      playing = true;
    });
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/test.mp3');
    var request = await http.get(Uri.parse(
        "https://api.voicerss.org/?key=a8002845a5ba4ed8a93b0c4b425cd1f0&hl=en-us&c=MP3&src=$text"));
    var bytes = await request.bodyBytes; //close();
    await file.writeAsBytes(bytes);
    print(file.path);
    audioPlayer.play(file.path, isLocal: true);
  }

  void stop() {
    audioPlayer.stop();
    setState(() {
      playing = false;
    });
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  void onComplete() {
    setState(() {
      playerState = PlayerState.stopped;
      playing = false;
    });
  }

  void setExample(){
    List list = widget.map["example"];
    for(int i = 1 ; i <= list[0].length; i++  ){
      List exMap = list[0][i.toString()];
      exampleList.add(TextSpanWidget(exampleList:exMap));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 45),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 8,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.map["title"],
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.map["type"],
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.map["structure"],
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.indigoAccent),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Example",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                      ],
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: exampleList
                    ))
                  ],
                ),
              ),
              Row(
                children: [
                  widget.firstCard
                      ? Container()
                      : Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.deepPurple)),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(40),
                            child: InkWell(
                              customBorder: new CircleBorder(),
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.deepPurple,
                                size: 30,
                              ),
                              onTap: () {
                                widget.pageController.previousPage(
                                    duration: Duration(seconds: 1),
                                    curve: Curves.decelerate);
                              },
                            ),
                          ),
                        ),
                  Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.deepPurple)),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(40),
                      child: InkWell(
                        customBorder: new CircleBorder(),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                        onTap: () {
                          if (widget.lastCard) {
                            widget.func();
                          } else {
                            widget.pageController.nextPage(
                                duration: Duration(seconds: 1),
                                curve: Curves.decelerate);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum PlayerState { stopped, playing, paused }
