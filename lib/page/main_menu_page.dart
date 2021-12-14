import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engbooster/actions/sign_in_actions.dart';
import 'package:engbooster/page/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'lesson_page.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

/// This is the private State class that goes with MainMenuPage.
class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;
  CollectionReference users = FirebaseFirestore.instance.collection('UserTable');
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    LessonPage(),
    ProfilePage()

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 1
          ? AppBar(
            centerTitle: true,
              title: const Text('Profile'),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      users.doc(FirebaseAuth.instance.currentUser.uid).get().then((DocumentSnapshot documentSnapshot){
                        if(documentSnapshot.exists){
                          Navigator.pushNamed(context, '/settingPage', arguments: documentSnapshot.get("Notification"));
                        }
                      });
                      // do something
                    },
                  )
                ])
          : null,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
