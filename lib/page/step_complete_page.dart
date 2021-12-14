import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StepCompletePage extends StatefulWidget {
  final int score;
  final Map user;
  final String lessonId;
  final int step;
  final Function func;

  StepCompletePage({this.score, this.user, this.lessonId, this.step, this.func});

  @override
  _StepCompletePageState createState() => _StepCompletePageState();
}

class _StepCompletePageState extends State<StepCompletePage> {
  CollectionReference users =
      FirebaseFirestore.instance.collection('UserTable');

  Future<void> updateSession() async {
    users
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('language')
        .doc(widget.user["current_learn"])
        .collection(widget.user["course_level"])
        .doc(widget.lessonId)
        .update({'step': widget.step})
        .then((value) => print("update"))
        .catchError((error) => print("Failed to add user: $error"));
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
    return Padding(
        padding:
        const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 45),
    child:Container(
        key: UniqueKey(),
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
                                  color: Colors.greenAccent,
                                ),
                                child: Center(
                                    child: Text(
                                  "+${widget.score} pts",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Text(
                        "Step complete!",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
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
                        "Next Step ",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple),
                      )),
                      onTap: widget.func
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
