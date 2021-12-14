import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PracticeCardWidget extends StatefulWidget {
  final PageController pageController;
  final bool firstCard;
  final Map map;
  final Function func;

  final bool lastCard;

  PracticeCardWidget(
      {this.pageController,
      this.firstCard = false,
      this.lastCard = false,
      this.map,
      this.func});

  @override
  _PracticeCardWidgetState createState() => _PracticeCardWidgetState();
}

class _PracticeCardWidgetState extends State<PracticeCardWidget> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAudioPlayer();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: FutureBuilder<String>(
                    future: downloadURL(widget.map['imgPath']),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data,
                          width: size.width / 1.75,
                        );
                      }
                      return Container();
                    }),
              )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Text(
                          widget.map["vocab"],
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 28),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        FutureBuilder<String>(
                            future: downloadURL(widget.map["audioPath"]),
                            builder: (context, snapshot) {
                              return InkWell(
                                onTap: playing
                                    ? () {
                                        stop();
                                      }
                                    : () {
                                        playByText(widget.map["vocab"]);
                                        // play(snapshot.data);
                                      },
                                child: Icon(
                                  Icons.volume_up_rounded,
                                  color: playing ? Colors.black : Colors.grey,
                                ),
                              );
                            })
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      child: Text(
                        widget.map["meaning"],
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    )
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
