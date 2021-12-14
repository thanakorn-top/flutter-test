import 'package:cached_network_image/cached_network_image.dart';
import 'package:engbooster/page/lesson_content_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class LessonCardWidget extends StatefulWidget {
  final String title;
  final String imgPath;
  final int totalStep;
  final String id;
  final bool learned;
  final String continueLearn;
  final int step;
  final String userId;
  final String currentLearn;
  final String courseLevel;

  LessonCardWidget(
      {this.title,
      this.imgPath,
      this.totalStep = 0,
      this.id,
      this.learned = false,
      this.continueLearn,
      this.step = 0,
      this.userId,
      this.currentLearn,
      this.courseLevel});

  @override
  _LessonCardWidgetState createState() => _LessonCardWidgetState();
}

class _LessonCardWidgetState extends State<LessonCardWidget> {
  // CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference users =
      FirebaseFirestore.instance.collection('UserTable');

  Future<String> downloadURL(String path) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(path)
        .getDownloadURL();
    return downloadURL;
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          LessonContentPage(
        lessonId: widget.id,
        userId: widget.userId,
        courseLevel: widget.courseLevel,
        currentLearn: widget.currentLearn,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Future<void> updateSession() async {
    DocumentSnapshot userCourseDoc = await users
        .doc(widget.userId)
        .collection('language')
        .doc(widget.currentLearn)
        .collection(widget.courseLevel)
        .doc(widget.id)
        .get();
    Map userCourse = userCourseDoc.data();
    if (userCourse['step'] == null) {
      users
          .doc(widget.userId)
          .collection('language')
          .doc(widget.currentLearn)
          .collection(widget.courseLevel)
          .doc(widget.id)
          .set({'learned': false, 'step': 1})
          .then((value) => print("update"))
          .catchError((error) => print("Failed to add user: $error"));
    }else{
      users
          .doc(widget.userId)
          .collection('language')
          .doc(widget.currentLearn)
          .collection(widget.courseLevel)
          .doc(widget.id)
          .update({'learned': false})
          .then((value) => print("update"))
          .catchError((error) => print("Failed to add user: $error"));
    }
    users
        .doc(widget.userId)
        .update({'continue': widget.id})
        .then((value) => print("update"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
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
            height: 100,
            width: double.infinity,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              child: InkWell(
                onTap: () {
                  updateSession();
                  Navigator.of(context).push(_createRoute());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  widget.learned ? learnedMark() : Container(),
                                  widget.step != 0 && !widget.learned
                                      ? stepMark(widget.totalStep, widget.step,
                                          Colors.deepPurple)
                                      : Container(),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 1,
                            child: widget.continueLearn == widget.id
                                ? continueMark()
                                : Container(),
                          ),
                        ],
                      )),
                      Container(
                        width: 95,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 40,
          child: FutureBuilder<String>(
              future: downloadURL(widget.imgPath),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return InkWell(
                    onTap: () {
                      updateSession();
                      Navigator.of(context).push(_createRoute());
                    },
                    child: Container(
                        height: 100,
                        child: (CachedNetworkImage(
                          imageUrl: snapshot.data,
                        ))),
                  );
                }
                return Container();
              }),
        )
      ],
    );
  }

  Widget learnedMark() {
    return Row(
      children: [
        ClipOval(
          child: Container(
            child: Icon(
              Icons.done,
              color: Colors.white,
              size: 12,
            ),
            color: Colors.green,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          "learned",
          style: TextStyle(fontSize: 11, color: Colors.green),
        ),
      ],
    );
  }

  Widget continueMark() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
        children: [
          ClipOval(
            child: Container(
              child: Icon(
                Icons.arrow_right,
                color: Colors.white,
                size: 16,
              ),
              color: Colors.indigo,
            ),
          ),
          SizedBox(
            width: 7,
          ),
          Text(
            "Continue",
            style: TextStyle(fontSize: 12, color: Colors.indigo),
          ),
        ],
      )
    ]);
  }

  Widget stepMark(int stepTotal, int step, Color color) {
    List<Widget> stepMark = [];

    Widget pass = Padding(
      padding: EdgeInsets.only(right: 3),
      child: Container(
        width: 6,
        height: 6,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      ),
    );

    Widget current = Padding(
      padding: EdgeInsets.only(right: 3),
      child: Container(
        width: 9,
        height: 9,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(9)),
        child: Padding(
          padding: EdgeInsets.all(3),
          // border width
          child: Container(
            // or ClipRRect if you need to clip the content
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // inner circle color
            ), // inner content
          ),
        ),
      ),
    );

    Widget notYet = Padding(
      padding: EdgeInsets.only(right: 3),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
            color: Colors.black38, borderRadius: BorderRadius.circular(6)),
      ),
    );

    for (int i = 1; i <= stepTotal; i++) {
      if (i == step) {
        stepMark.add(current);
      } else if (i < step) {
        stepMark.add(pass);
      } else {
        stepMark.add(notYet);
      }
    }

    return Row(
      children: stepMark,
    );
  }
}
