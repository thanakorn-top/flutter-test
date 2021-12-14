import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engbooster/widget/lesson_card_widget.dart';
import 'package:engbooster/widget/lesson_head_widget.dart';
import 'package:engbooster/widget/level_to_learn_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';

class LessonPage extends StatefulWidget {
  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  // CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference users = FirebaseFirestore.instance.collection('UserTable');
  CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');
  Map userProfile;
  Map<String, Map> userCourse = new Map();

  Future<String> downloadURL(String path) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(path)
        .getDownloadURL();
    return downloadURL;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
          //stream: users.doc('v2qk37gT92XenOh4OEFXIM50dLo2').snapshots(),
          stream: users.doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.active) {
              userProfile = snapshot.data.data();
              return StreamBuilder<QuerySnapshot>(
                  /*stream: users
                      .doc('v2qk37gT92XenOh4OEFXIM50dLo2')
                      .collection('language')
                      .doc(userProfile['current_learn'])
                      .collection(userProfile['course_level'])
                      .snapshots(),*/
                  stream: users
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection('language')
                      .doc(userProfile['current_learn'])
                      .collection(userProfile['course_level'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      snapshot.data.docs.forEach((doc) {
                        userCourse[doc.id] = doc.data();
                      });
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<DocumentSnapshot>(
                                future: courses
                                    .doc(userProfile['current_learn'])
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    Map map = snapshot.data.data();
                                    return FutureBuilder<String>(
                                        future: downloadURL(map['img_path']),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return LessonHeadWidget(
                                                title: map['title'],
                                                detail: map['detail'],
                                                imgPath: snapshot.data);
                                          }
                                          return Container();
                                        });
                                  }
                                  return Container();
                                }),
                            LevelToLearnWidget(
                              levelText: userProfile['course_level'],
                            ),
                            FutureBuilder<QuerySnapshot>(
                                future: courses
                                    .doc(userProfile['current_learn'])
                                    .collection('level')
                                    .doc(userProfile['course_level'])
                                    .collection('lesson')
                                    .orderBy('lesson_number', descending: false)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<Widget> list = [];
                                    snapshot.data.docs.forEach((doc) {
                                      Map<String, Object> lessonList =
                                          doc.data();
                                      if (userCourse[doc.id] != null) {
                                        list.add(LessonCardWidget(
                                          title: lessonList['title'],
                                          imgPath: lessonList['img_path'],
                                          totalStep: lessonList['total_step'],
                                          id: doc.id,
                                          continueLearn: userProfile
                                              ['continue'],
                                          learned: userCourse[doc.id]
                                              ['learned'],
                                          step: userCourse[doc.id]['step'],
                                          /*userId:
                                              'v2qk37gT92XenOh4OEFXIM50dLo2',*/
                                          userId:
                                              FirebaseAuth.instance.currentUser.uid,
                                          currentLearn:
                                              userProfile['current_learn'],
                                          courseLevel:
                                              userProfile['course_level'],
                                        ));
                                      } else {
                                        list.add(LessonCardWidget(
                                          title: lessonList['title'],
                                          imgPath: lessonList['img_path'],
                                          totalStep: lessonList['total_step'],
                                          id: doc.id,
                                          /*userId:
                                          'v2qk37gT92XenOh4OEFXIM50dLo2',*/
                                          userId:
                                          FirebaseAuth.instance.currentUser.uid,
                                          currentLearn:
                                          userProfile['current_learn'],
                                          courseLevel:
                                          userProfile['course_level'],
                                        ));
                                      }
                                    });

                                    return Column(children: list);
                                  }

                                  return Container();
                                }),
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: Container()
                    );
                  });
            }

            return Center(
              child: Container()
            );
          }),
    );
  }
}