import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';

class ChangeLevelPage extends StatefulWidget {
  const ChangeLevelPage({Key key}) : super(key: key);

  @override
  _ChangeLevelPageState createState() => _ChangeLevelPageState();
}

class _ChangeLevelPageState extends State<ChangeLevelPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('UserTable');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  String selectedLevel = "";
  bool shouldPop = true;

  List<Widget> levelList(){
    List<Widget> data = [];
    List<String> title = ["Elementary","Intermediate","Advance"];
    for(String entry in title){
      var levelTile = ListTile(
        title: Text(entry),
        onTap: (){
          setState(() {
            selectedLevel = entry;
          });
        },
        trailing: selectedLevel==entry ? Icon(Icons.check_circle, color: Colors.green,) : null,
      );
      data.add(levelTile);
      data.add(Divider());
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if(selectedLevel.isEmpty)
      selectedLevel = args;
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Level"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if(selectedLevel!=args){
            await users.doc(FirebaseAuth.instance.currentUser.uid).update({
              "course_level" : selectedLevel
            });
          }
          return shouldPop;
        },
        child: ListView(
          children: levelList(),
        ),
      ),
    );
  }
}

/*
class ChangeLevelPage extends StatelessWidget {
  const ChangeLevelPage({Key key}) : super(key: key);

  List<Widget> levelList(){
    List<Widget> data = [];
    List<String> title = ["Elementary","Intimidate","Expert"];
    for(String entry in title){
      var levelTile = ListTile(
        title: Text(entry),
        onTap: (){

        },
        trailing: Icon(Icons.check_circle, color: Colors.green,),
      );
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Level"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return shouldPop;
        },
        child: ListView(
          children: [

          ],
        ),
      ),
    );
  }
}*/
