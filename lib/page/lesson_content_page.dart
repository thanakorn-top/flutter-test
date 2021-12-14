import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engbooster/page/lesson_complete_page.dart';
import 'package:engbooster/page/step_complete_page.dart';
import 'package:engbooster/widget/exit_modal_bottom_widget.dart';
import 'package:engbooster/widget/tense_card_widget.dart';
import 'package:engbooster/widget/vocab_card_widget.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LessonContentPage extends StatefulWidget {
  final String lessonId;
  final String userId;
  final String currentLearn;
  final String courseLevel;

  LessonContentPage(
      {@required this.lessonId,
      this.userId,
      this.currentLearn,
      this.courseLevel});

  @override
  _LessonContentPageState createState() => _LessonContentPageState();
}

class _LessonContentPageState extends State<LessonContentPage> {
  final PageController pageController = PageController(initialPage: 0);
  int _curr = 0;
  int _page = 3;
  int _saveStep = 0;
  double linearPro = 0.0;
  StreamController<Map> contentController = StreamController<Map>();
  CollectionReference users =
      FirebaseFirestore.instance.collection('UserTable');
  CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');
  bool finishedStep = false;
  int stepScore = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContent();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    contentController.close();
  }

  Future<bool> exitFunc() async => await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      builder: (context) {
        return ExitModalBottomWidget();
      });

  Future getContent() async {
    Map<String, Object> map = new Map();
    DocumentSnapshot userDoc =
        // await users.doc('v2qk37gT92XenOh4OEFXIM50dLo2').get();
        await users.doc(FirebaseAuth.instance.currentUser.uid).get();
    Map userProfile = userDoc.data();
    DocumentSnapshot userCourseDoc = await users
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('language')
        .doc(userProfile['current_learn'])
        .collection(userProfile['course_level'])
        .doc(widget.lessonId)
        .get();
    Map userCourse = userCourseDoc.data();
    QuerySnapshot stepDoc = await courses
        .doc(userProfile['current_learn'])
        .collection('level')
        .doc(userProfile['course_level'])
        .collection('lesson')
        .doc(widget.lessonId)
        .collection("content")
        .orderBy('step', descending: false)
        .get();
    List content = [];

    for (int i = 0; i < stepDoc.docs.length; i++) {
      QuerySnapshot detailDoc = await courses
          .doc(userProfile['current_learn'])
          .collection('level')
          .doc(userProfile['course_level'])
          .collection('lesson')
          .doc(widget.lessonId)
          .collection("content")
          .doc(stepDoc.docs[i].id)
          .collection("detail")
          .get();
      Map<String, Object> lessonList = stepDoc.docs[i].data();
      lessonList["total_step"] = detailDoc.docs.length;
      lessonList["detail"] = detailDoc.docs;
      content.add(lessonList);
    }
    print("--------------------------------------");
    print(userCourse["step"]);
    _saveStep = userCourse["step"];
    map["userProfile"] = userProfile;
    map["userCourse"] = userCourse;
    map["content"] = content;
    contentController.add(map);
  }

  Route _lessonCompleteRoute(Map user, int score) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          LessonCompletePage(
        score: score,
        lessonId: widget.lessonId,
        user: user,
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

  void lessonComplete(Map user, int score, int step) async {
    if (_saveStep == step) {
      await Navigator.of(context).push(_lessonCompleteRoute(user, score));
      Navigator.pop(context);
    } else {
      _saveStep++;
      stepScore = score;
      setState(() {
        finishedStep = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: SafeArea(
          child: StreamBuilder<Map>(
              stream: contentController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map userProfileMap = snapshot.data["userProfile"];
                  List contentList = snapshot.data["content"];
                  Map curContent = new Map();
                  for (int i = 0; i < contentList.length; i++) {
                    if (contentList[i]["step"] == _saveStep) {
                      curContent = contentList[i];
                    }
                  }
                  List<Widget> contentCardList = [];
                  List detailList = curContent["detail"];
                  _page = detailList.length;
                  switch (curContent["lesson"]) {
                    case "present_simple_tense":
                      {
                        for (int i = 0; i < detailList.length; i++) {
                          Map curDetail = detailList[i].data();
                          if (i == (detailList.length - 1) && i == 0) {
                            contentCardList.add(TenseCardWidget(
                              pageController: pageController,
                              map: curDetail,
                              lastCard: true,
                              firstCard: true,
                              func: () {
                                lessonComplete(
                                    userProfileMap,
                                    curContent["total_score"],
                                    contentList.length);
                              },
                            ));
                          } else if (i == (detailList.length - 1)) {
                            contentCardList.add(TenseCardWidget(
                              pageController: pageController,
                              map: curDetail,
                              lastCard: true,
                              func: () {
                                lessonComplete(
                                    userProfileMap,
                                    curContent["total_score"],
                                    contentList.length);
                              },
                            ));
                          } else if (i == 0) {
                            contentCardList.add(TenseCardWidget(
                              pageController: pageController,
                              map: curDetail,
                              firstCard: true,
                            ));
                          } else {
                            contentCardList.add(TenseCardWidget(
                                pageController: pageController,
                                map: curDetail));
                          }
                        }
                      }
                      break;
                    case "vocab":
                      {
                        for (int i = 0; i < detailList.length; i++) {
                          Map curDetail = detailList[i].data();
                          print("=== $curDetail");
                          if (i == (detailList.length - 1) && i == 0) {
                            contentCardList.add(VocabCardWidget(
                              pageController: pageController,
                              map: curDetail,
                              lastCard: true,
                              firstCard: true,
                              func: () {
                                lessonComplete(
                                    userProfileMap,
                                    curContent["total_score"],
                                    contentList.length);
                              },
                            ));
                          } else if (i == (detailList.length - 1)) {
                            contentCardList.add(VocabCardWidget(
                              pageController: pageController,
                              map: curDetail,
                              lastCard: true,
                              func: () {
                                lessonComplete(
                                    userProfileMap,
                                    curContent["total_score"],
                                    contentList.length);
                              },
                            ));
                          } else if (i == 0) {
                            contentCardList.add(VocabCardWidget(
                              pageController: pageController,
                              map: curDetail,
                              firstCard: true,
                            ));
                          } else {
                            contentCardList.add(VocabCardWidget(
                                pageController: pageController,
                                map: curDetail));
                          }
                        }
                      }
                      break;
                  }

                  return Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 25, right: 25, left: 25),
                          child: Row(
                            children: [
                              stepMark(
                                  contentList.length, _saveStep, Colors.white),
                              Spacer(),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(40),
                                  child: InkWell(
                                    customBorder: new CircleBorder(),
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onTap: () async {
                                      if (await exitFunc()) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                child: child, scale: animation);
                          },
                          child: finishedStep
                              ? StepCompletePage(
                                  user: userProfileMap,
                                  score: stepScore,
                                  step: _saveStep,
                                  lessonId: widget.lessonId,
                                  func: () {
                                    setState(() {
                                      finishedStep = false;
                                    });
                                  },
                                )
                              : Stack(
                                  children: [
                                    PageView(
                                        physics: NeverScrollableScrollPhysics(),
                                        onPageChanged: (num) {
                                          setState(() {
                                            _curr = num;
                                            linearPro =
                                                (200 / (_page - 1)) * _curr;
                                          });
                                        },
                                        scrollDirection: Axis.horizontal,
                                        controller: pageController,
                                        children: contentCardList),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 15, top: 10),
                                        child: Center(
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: Color(0xffe8e8e8)
                                                      .withOpacity(0.5),
                                                ),
                                                width: 200,
                                                height: 2.2,
                                              ),
                                              AnimatedContainer(
                                                width: linearPro,
                                                duration:
                                                    const Duration(seconds: 1),
                                                curve: Curves.fastOutSlowIn,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    color: Colors.white,
                                                  ),
                                                  width: 200,
                                                  height: 2.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
      onWillPop: () async {
        if (await exitFunc()) {
          Navigator.pop(context);
        }
        return false;
      },
    );
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
          padding: EdgeInsets.all(2.5),
          // border width
          child: Container(
            // or ClipRRect if you need to clip the content
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple.shade300, // inner circle color
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
