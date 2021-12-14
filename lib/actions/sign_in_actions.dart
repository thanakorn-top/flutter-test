import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:engbooster/widget/show_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:engbooster/model/radio_model.dart';

CollectionReference users = FirebaseFirestore.instance.collection('UserTable');

Future<void> addUser(
    BuildContext context, Map<String, dynamic> data, String documentName) {
  return users.doc(documentName).set(data).then((value) => print("success"))
      // .then((value) => showMessageBox(context, "Success", "Register Success",
      //     actions: [dismissButton(context)]))
      // .then((value) => Navigator.pushNamed(context, '/selectPriceCoursePage'))
      .catchError((e) {
    print("error");
    print(e);
  });
}

Future<void> updateCoursePrice(BuildContext context, String price) {
  return users
      .doc(getCurrentUser().uid)
      .update({'price_course': price})
      .then((value) => Navigator.pushReplacementNamed(context, '/mainMenuPage'))
      .catchError((e) {});
}

Future<void> updateUser(BuildContext context, Map<String, dynamic> data) {
  return users
      .doc(getCurrentUser().uid)
      .update(data)
      .then((value) => print("success"))
      // .then((value) => Navigator.pushReplacementNamed(context, '/mainMenuPage'))
      .catchError((e) {});
}

Future<void> createLessonField(BuildContext context,String courseLearn){
  return users
      .doc(getCurrentUser().uid)
      .collection("language")
      .doc(courseLearn)
      .set({})
      .then((value) => print("create language collection success"))
      .catchError((e){});
}

Future<void> initiateNotification() async {
  await FirebaseMessaging.instance.subscribeToTopic('App');
}

Future<UserCredential> signInWithGoogle(BuildContext context, Map model) async {
  Map<String, dynamic> args = {};
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  User _user;
  // Once signed in, return the UserCredential
  UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);

  _user = authResult.user;

  if (authResult.additionalUserInfo.isNewUser) {
    Map<String, dynamic> args = {
      "name": _user.displayName,
      "course_level": model['level'],
      "explain": model['explain'],
      "current_learn": model['learn'],
      "total_score" : 0,
      "profile_level" : 1,
      "Notification" : true
    };
    addUser(context, args, _user.uid.toString());
    createLessonField(context,args["current_learn"]);
    initiateNotification();
    getUserDetail(context);
  } else {
    Map<String, dynamic> args = {
      "name": _user.displayName,
      "course_level": model['level'],
      "explain": model['explain'],
      "current_learn": model['learn'],
    };
    updateUser(context, args);
    getUserDetail(context);
  }

  // User currentUser = FirebaseAuth.instance.currentUser;

  // assert(_user.uid == currentUser.uid);

  // if (_user.uid == currentUser.uid) {
  //   Navigator.pushNamed(context, '/selectPriceCoursePage', arguments: args);
  //   // Navigator.pushReplacementNamed(context, '/homepage');
  //   print("User Name: ${_user.displayName}");
  //   print("User Email ${_user.email}");
  // }
}

Future<UserCredential> signInWithFacebook(
    BuildContext context, Map model) async {
  // Trigger the sign-in flow
  final AccessToken result = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final facebookAuthCredential = FacebookAuthProvider.credential(result.token);

  // Once signed in, return the UserCredential

  UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  User _user = authResult.user;

  if (authResult.additionalUserInfo.isNewUser) {
    Map<String, dynamic> args = {
      "name": _user.displayName,
      "course_level": model['level'],
      "explain": model['explain'],
      "current_learn": model['learn'],
      "total_score" : 0,
      "profile_level" : 1,
      "Notification" : true
    };
    addUser(context, args, _user.uid.toString());
    createLessonField(context,args["current_learn"]);
    initiateNotification();
    getUserDetail(context);
  } else {
    Map<String, dynamic> args = {
      "name": _user.displayName,
      "course_level": model['level'],
      "explain": model['explain'],
      "current_learn": model['learn'],
    };
    updateUser(context, args);
    getUserDetail(context);
  }

  return authResult;
}

User getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}

getUserDetail(BuildContext context) {
  User currentUser = FirebaseAuth.instance.currentUser;
  print(currentUser);
  if (currentUser != null) {
    var uid = currentUser.uid;

    users.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // var data = documentSnapshot.data();

        DocumentSnapshot ds = documentSnapshot;
        Map<String, dynamic> map = ds.data();
        print('Document data: ${map['level']}');
        print('Document data: ${map['name']}');

        if (map['price_course'] == null||map['price_course'] == '') {
          print('Document data: ${map['name']}');
          // SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/selectPriceCoursePage',
              arguments: map);
          // });
        } else {
          print('Document data: ${map['level']}');
          // SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/mainMenuPage');
          // });
        }
      }
    });
  } else {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, '/selectCourseFirstPage');
    });
  }
}
