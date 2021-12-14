import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LessonCompletePage extends StatefulWidget {
  final int score;
  final Map user;
  final String lessonId;
  LessonCompletePage({this.score, this.user, this.lessonId});

  @override
  _LessonCompletePageState createState() => _LessonCompletePageState();
}

class _LessonCompletePageState extends State<LessonCompletePage> {

  CollectionReference users = FirebaseFirestore.instance.collection('UserTable');
  Future<void> updateSession() {
    users
        // .doc('v2qk37gT92XenOh4OEFXIM50dLo2')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('language')
        .doc(widget.user["current_learn"])
        .collection(widget.user["course_level"])
        .doc(widget.lessonId)
        .update({
      'learned': true,
      'step': 1
    })
        .then((value) => print("update"))
        .catchError((error) => print("Failed to add user: $error"));
    // users.doc('v2qk37gT92XenOh4OEFXIM50dLo2').get().then((value) {
    users.doc(FirebaseAuth.instance.currentUser.uid).get().then((value) {
      Map userProfile = value.data();
      users
          // .doc('v2qk37gT92XenOh4OEFXIM50dLo2')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'total_score': userProfile["total_score"]+widget.score ,
        'continue':''
      })
          .then((value) => print("update"))
          .catchError((error) => print("Failed to add user: $error"));
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateSession();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 120, bottom: 25, right: 25, left: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width / 3.2 + 30,
                          child: Stack(
                            children: [
                              Image(
                                image: AssetImage(
                                  "assets/images/success.png",
                                ),
                                width: size.width / 3.2,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 60,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    color: Colors.greenAccent,),
                                  child: Center(child: Text("+${widget.score} pts",style: TextStyle(fontSize: 11,fontWeight: FontWeight.w700,color: Colors.black),)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 35,),
                        Text("Lesson complete!",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 24),textAlign: TextAlign.center,),
                        SizedBox(height: 35,),
                        Text("You've reached the daily target.\nPractice every day to build\n your streak.",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55),
                        border: Border.all(color: Colors.deepPurple)),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(55),
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(55),
                        ),
                        child: Center(
                            child: Text(
                          "continue",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple),
                        )),
                        onTap: () {
                          Navigator.pop(context,true);
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
          Navigator.pop(context,true);
        return false;
      },
    );
  }
}
