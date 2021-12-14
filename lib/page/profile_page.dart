import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

/// This is the private State class that goes with ProfilePage.
class _ProfilePageState extends State<ProfilePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('UserTable');
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  User loginUser = FirebaseAuth.instance.currentUser;
/*  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/mainMenuPage');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/profilePage');
    }
  }*/

  int calculateMaxScore(int level){
    int maxScore=0;
    for(int i=1;i<=level;i++){
      maxScore += i*10;
    }
    return maxScore;
  }

  void updateLevel(int level,int score){
    while(calculateMaxScore(level)<=score){
      level++;
    }
    users.doc(FirebaseAuth.instance.currentUser.uid).update({
      "profile_level" : level
    });
  }

  @override
  Widget build(BuildContext context) {
    int maxScore;
    /*if(loginUser==null){
      Navigator.pushReplacementNamed(context, "/selectCourseSecondPage");
      return Text("redirecting");
    }*/
    return SafeArea(
      child: Scaffold(
        /*appBar: AppBar(
            title: const Text('BottomNavigationBar Sample'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/settingPage');
                  // do something
                },
              )
            ]),*/
        body: StreamBuilder<DocumentSnapshot>(
          stream: users.doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
          builder: (context,snapshot) {
            if (snapshot.hasError) {
            print(snapshot.error.toString());
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            if (snapshot.hasData && snapshot.connectionState == ConnectionState.active){
              updateLevel(snapshot.data.get("profile_level"), snapshot.data.get("total_score"));
              maxScore = calculateMaxScore(snapshot.data.get("profile_level"));
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Text("${snapshot.data.get("name")}",style: TextStyle(fontSize: 24),),
                      SizedBox(height: 20,),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 43,
                              backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
                            ),
                          ),
                          /*Container(
                            padding: EdgeInsets.fromLTRB(62, 62, 0, 0),
                            child: GestureDetector(
                              onTap: (){
                                print("Image edit button pressed");
                              },
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 18,
                                )
                              ),
                            ),
                          )*/
                        ],
                      ),
                      SizedBox(height: 20,),
                      Text("Level ${snapshot.data.get("profile_level")}",style: TextStyle(fontSize: 24),),
                      SizedBox(height: 20,),
                      Text("${snapshot.data.get("total_score")} pts"),
                      SizedBox(height: 10,),
                      Container(
                        height: 3,
                        width: MediaQuery.of(context).size.width*0.6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [snapshot.data.get("total_score")/maxScore,1-(maxScore-snapshot.data.get("total_score")/maxScore)],
                                colors: [
                                  Colors.black,
                                  Colors.white
                                ]
                            )
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("${maxScore - snapshot.data.get("total_score")} pts left to level up"),
                      SizedBox(height: 30,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white60
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.build_circle),
                            SizedBox(width: 5,),
                            Expanded(
                              child: Text("Unlock full access and remove ads"),
                            ),
                            SizedBox(width: 20,),
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.teal,
                              // onPressed: () {},
                              child: MaterialButton(
                                child: Text("Unlock now"),
                                onPressed: () async {
                                  //Navigator.pushNamed(context, "/selectPriceCoursePage");
                                  print(FirebaseAuth.instance.currentUser.photoURL);
                                  print(await FirebaseMessaging.instance.getNotificationSettings());
                                },
                              ),
                            ),
                            SizedBox(width: 10,)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            return Text("Loading");
          }
        ),
        /*Center(
          child: Column(
            children: [
              SizedBox(height: 30,),
              Text("Profile Username",style: TextStyle(fontSize: 24),),
              SizedBox(height: 40,),
              Text("Level 2",style: TextStyle(fontSize: 24),),
              SizedBox(height: 40,),
              Text("12 pts"),
              SizedBox(height: 10,),
              Container(
                height: 3,
                width: MediaQuery.of(context).size.width*0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [12/18,1-(12/18)],
                    colors: [
                      Colors.black,
                      Colors.white
                    ]
                  )
                ),
              ),
              SizedBox(height: 10,),
              Text("6 pts left to level up"),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white60
                ),
                child: Row(
                  children: [
                    Icon(Icons.build_circle),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Text("Unlock full access and remove ads"),
                    ),
                    SizedBox(width: 20,),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(15),
                      // onPressed: () {},
                      child: MaterialButton(
                        child: Text("Unlock now"),
                        onPressed: (){
                          Navigator.pushNamed(context, "/selectPriceCoursePage");
                        },
                      ),
                    ),
                    SizedBox(width: 10,)
                  ],
                ),
              )
            ],
          ),
        ),*/
        /*bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Settings',
              backgroundColor: Colors.pink,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),*/
      ),
    );
  }
}
