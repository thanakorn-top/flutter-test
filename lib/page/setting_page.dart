import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// class SettingPage extends StatefulWidget {
//   @override
//   _SettingPageState createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(child: Text("Setting Page"),),
//     );
//   }
// }

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Settings"),
        ),
        body: UserInformation());
  }
}
/*
class UserInformation extends StatefulWidget {
  const UserInformation({Key key}) : super(key: key);

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  bool _toggleSwitch = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
    FirebaseFirestore.instance.collection('UserTable');
    final toggle = Provider.of<ToggleSwitch>(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: users.doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (snapshot.hasData && snapshot.connectionState == ConnectionState.active){
          return ListView(
            children: [
              *//*ListTile(
                  //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                  title: Text('My native language'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${snapshot.data.get("Native Language")}', style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(width: 5),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/selectLanguagePage', arguments: ScreenArguments('My native language','${snapshot.data.get("Native Language")}'));
                  },
                ),
                Divider(),
                ListTile(
                  //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                  title: Text('I want to learn'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${snapshot.data.get("WantToLearn")}', style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(width: 5),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/selectLanguagePage', arguments: ScreenArguments('I want to learn','${snapshot.data.get("WantToLearn")}'));
                  },
                ),
                Divider(),*//*
              ListTile(
                //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                title: Text("Notification"),
                trailing: Switch(
                  onChanged: (value){
                    toggle.change(value);
                  },
                  value: toggle.getToggle(),
                  activeColor: Colors.blue,
                  inactiveThumbColor: Colors.grey,
                ),
              ),
              Divider(),
              ListTile(
                //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                title: Text("Write Feedback"),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){
                  Navigator.pushNamed(context, "/contractPage");
                },
              ),
              Divider(),
              ListTile(
                //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                title: Text("My Feedbacks"),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){
                  Navigator.pushNamed(context, "/feedbackPage");
                },
              ),
              Divider(),
              ListTile(
                title: Text("Terms of Service"),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){},
              ),
              Divider(),
              ListTile(
                title: Text("Privacy Policy"),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){},
              ),
              Divider(),
              ListTile(
                trailing: Icon(Icons.logout),
                title: Text("Sign out"),
                onTap: () async {
                  //GoogleSignIn().signOut();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/selectCourseFirstPage');
                },
              ),
              Divider(),
            ],
          );
        }
        *//*return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> map = document.data();
            print('Document data: ${map['Desc']}');
            print('Document data: ${map['Name']}');
            return new ListTile(
              title: new Text(map['Name']),
              subtitle: new Text(map['Desc']),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                 Navigator.pushReplacementNamed(context, '/selectCourseFirstPage');
                // deleteFromFireBase(context,map['name']);
              },
            );
          }).toList(),
        );*//*

        return Text('Loading');
      },
    );
  }
}*/

class ToggleSwitch with ChangeNotifier{
 bool _toggle;

 ToggleSwitch();


 getToggle() => _toggle;
 setToggle(bool toggle) => _toggle = toggle;

  void change(){
    _toggle = !_toggle;
    updateData(_toggle);
    checkNotification(_toggle);
    print(_toggle);
    notifyListeners();
  }
}

Future<void> updateData(bool value){
  return FirebaseFirestore.instance.collection('UserTable').doc(FirebaseAuth.instance.currentUser.uid).update({
    "Notification" : value
  }).then((value) => print("Notification Updated"))
      .catchError((error)=>print("Failed to update Notification : $error"));
}

Future<void> checkNotification(bool toggle) async {
  print(toggle);
  if(toggle == true){
    await FirebaseMessaging.instance.subscribeToTopic('App').then((value) => print("Notification changed"));
  }
  else{
    await FirebaseMessaging.instance.unsubscribeFromTopic('App').then((value) => print("Notification changed"));
  }
}

class UserInformation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('UserTable');
    final toggle = Provider.of<ToggleSwitch>(context);
    final args = ModalRoute.of(context).settings.arguments;
    if(toggle.getToggle()==null)
      toggle.setToggle(args);
    checkNotification(toggle.getToggle());
    /*users.doc(FirebaseAuth.instance.currentUser.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        toggle.setToggle(documentSnapshot.get("Notification"));
      }
    });*/
    return ListView(
      children: [
        ListTile(
          //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
          title: Text("Notification"),
          trailing: Switch(
            onChanged: (value){
              toggle.change();
            },
            value: toggle.getToggle(),
            activeColor: Theme.of(context).primaryColor,
            inactiveThumbColor: Colors.grey,
            dragStartBehavior: DragStartBehavior.start,
          ),
        ),
        Divider(),
        ListTile(
          //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
          title: Text("Change Level"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: (){
            users.doc(FirebaseAuth.instance.currentUser.uid).get().then((DocumentSnapshot documentSnapshot){
              if(documentSnapshot.exists){
                Navigator.pushNamed(context, '/changeLevelPage', arguments: '${documentSnapshot.get("course_level")}');
              }
            });
          },
        ),
        Divider(),
        ListTile(
          //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
          title: Text("Explain Language"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: (){
            users.doc(FirebaseAuth.instance.currentUser.uid).get().then((DocumentSnapshot documentSnapshot){
              if(documentSnapshot.exists){
                Navigator.pushNamed(context, '/selectLanguagePage', arguments: ScreenArguments('Explain in','${documentSnapshot.get("explain")}'));
              }
            });
          },
        ),
        Divider(),
        ListTile(
          //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
          title: Text("Write Feedback"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: (){
            Navigator.pushNamed(context, "/contractPage");
          },
        ),
        Divider(),
        ListTile(
          //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
          title: Text("My Feedbacks"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: (){
            Navigator.pushNamed(context, "/feedbackPage");
          },
        ),
        Divider(),
        ListTile(
          title: Text("Terms of Service"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: (){

          },
        ),
        Divider(),
        ListTile(
          title: Text("Privacy Policy"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: (){

          },
        ),
        Divider(),
        ListTile(
          trailing: Icon(Icons.logout),
          title: Text("Sign out"),
          onTap: () async {
            //GoogleSignIn().signOut();
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/selectCourseFirstPage');
          },
        ),
        Divider(),
      ],
    );

    /*return StreamBuilder<DocumentSnapshot>(
      stream: users.doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (snapshot.hasData){
          return ListView(
            children: [
              *//*ListTile(
                  //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                  title: Text('My native language'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${snapshot.data.get("Native Language")}', style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(width: 5),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/selectLanguagePage', arguments: ScreenArguments('My native language','${snapshot.data.get("Native Language")}'));
                  },
                ),
                Divider(),
                ListTile(
                  //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                  title: Text('I want to learn'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${snapshot.data.get("WantToLearn")}', style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(width: 5),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/selectLanguagePage', arguments: ScreenArguments('I want to learn','${snapshot.data.get("WantToLearn")}'));
                  },
                ),
                Divider(),*//*

                ListTile(
                  //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                  title: Text("Notification"),
                  trailing: Switch(
                    onChanged: (value){
                      toggle.change(value);
                    },
                    value: toggle.getToggle(),
                    activeColor: Colors.blue,
                    inactiveThumbColor: Colors.grey,
                    dragStartBehavior: DragStartBehavior.start,
                  ),
                ),
                Divider(),
                ListTile(
                  //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                  title: Text("Write Feedback"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    Navigator.pushNamed(context, "/contractPage");
                  },
                ),
                Divider(),
                ListTile(
                  //contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                  title: Text("My Feedbacks"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    Navigator.pushNamed(context, "/feedbackPage");
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Terms of Service"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){},
                ),
                Divider(),
                ListTile(
                  title: Text("Privacy Policy"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){},
                ),
                Divider(),
                ListTile(
                  trailing: Icon(Icons.logout),
                  title: Text("Sign out"),
                  onTap: () async {
                    //GoogleSignIn().signOut();
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/selectCourseFirstPage');
                  },
                ),
                Divider(),
              ],
          );
        }
        return Text('Loading');
      },
    );*/
  }
}

class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
