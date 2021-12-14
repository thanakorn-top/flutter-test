import 'dart:async';
import 'dart:io';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ContentDetailWordWidget extends StatefulWidget {
  final double x ;
  final double y ;
  final Size size ;
  final String vocab;
  final String structure;
  final String meaning ;
  ContentDetailWordWidget({this.x, this.y, this.size, this.vocab, this.structure, this.meaning});

  @override
  _ContentDetailWordWidgetState createState() => _ContentDetailWordWidgetState();
}

class _ContentDetailWordWidgetState extends State<ContentDetailWordWidget> {

  AudioPlayer audioPlayer = AudioPlayer();
  bool playing = false;
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  PlayerState playerState = PlayerState.stopped;
  Duration duration;
  Duration position;

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

  @override
  void initState() {
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
    return Stack(
      children: [
        Positioned(
          top: widget.y,
          right: 40,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            width: widget.size.width - 80,
            child: Stack(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Material(
                        child: InkWell(
                          onTap: playing
                              ? () {
                            stop();
                          }
                              : () {
                            playByText(widget.vocab);
                          },
                          child: Icon(
                            Icons.volume_up_rounded,
                            color: playing ? Colors.black : Colors.grey,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        width: widget.size.width - 120,
                        child: Text(
                          widget.vocab,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: widget.size.width - 120,
                        child: Text(
                          widget.structure,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.blue[400]),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: widget.size.width - 120,
                        child: Text(
                          widget.meaning,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Positioned(
        //   top: widget.y - 19,
        //   left: widget.x-20,
        //   child: CustomPaint(
        //     size: Size(40, 40),
        //     painter: PaintTriangle(backgroundColor: Colors.white),
        //   ),
        // )
      ],
    );
  }
}

enum PlayerState { stopped, playing, paused }

class PaintTriangle extends CustomPainter {
  final Color backgroundColor;

  PaintTriangle({
    @required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height;
    final x = size.width;

    final paint = Paint()..color = backgroundColor;
    final path = Path();

    path
      ..moveTo(0, y)
      ..lineTo((x / 2), (y / 1.5))
      ..lineTo(x, y);
    canvas.drawShadow(path.shift(Offset(0, -3.5)), Colors.black38, 1, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
