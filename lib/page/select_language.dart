import 'dart:async';

import 'package:engbooster/page/setting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_svg/flutter_svg.dart';

class SelectLanguagePage extends StatefulWidget {
  const SelectLanguagePage({Key key}) : super(key: key);

  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}


class _SelectLanguagePageState extends State<SelectLanguagePage> {
  int _showTrail = 0;
  String selectedLanguage = "";
  bool shouldPop = true;
  Map<String,String> country;
  CollectionReference users = FirebaseFirestore.instance.collection('UserTable');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    country = {
      "Thai" : "Flag/th.svg",
      "English" : "Flag/us.svg",
    };
  }

  Future<String> downloadFlagURL(String url) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(url)
        .getDownloadURL();
    print(downloadURL);
    return downloadURL;
  }

/*
  List<Widget> countryList(Map map){
    List<Widget> data = [];
    print(map);
    map.forEach((key, value) async {
      //String flagUrl = await downloadFlagURL(value);
      print(value);
      var countryTile = ListTile(
        leading: Image(image: NetworkImage(await downloadFlagURL(value)),width: 30,),
        title: Text(key),
        trailing: selectedLanguage == key ? Icon(Icons.check_circle, color: Colors.green,) : null,
        onTap: (){
          setState(() {
            selectedLanguage = key;
          });
        },
      );
      data.add(countryTile);
      data.add(Divider());
      //print(data);
    });
    print("return");
    return data;
  }
*/

  Future<List<Widget>> asCountryList(Map map) async{
    List<Widget> data = [];
    for(var mapEntry in map.entries){
      String flagUrl = await downloadFlagURL(mapEntry.value);
      print(mapEntry.value);
      var countryTile = ListTile(
        //leading: Image(image: NetworkImage(flagUrl),width: 30,),
        leading: SvgPicture.network(flagUrl,width: 40,),
        title: Text(mapEntry.key),
        trailing: selectedLanguage == mapEntry.key ? Icon(Icons.check_circle, color: Colors.green,) : null,
        onTap: (){
          setState(() {
            selectedLanguage = mapEntry.key;
            print('change '+selectedLanguage);
          });
        },
      );
      data.add(countryTile);
      data.add(Divider());
    }
    print("return");
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    if(selectedLanguage.isEmpty)
      selectedLanguage = args.message;
    if(selectedLanguage=="English")
      _showTrail = 0;
    else
      _showTrail = 1;
    print(args.message);
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if(selectedLanguage != args.message&&args.title=="My native language"){
             await users.doc("test").update({
                "Native Language" : selectedLanguage
              });
            }
            else if(selectedLanguage != args.message&&args.title=="I want to learn"){
             await users.doc("test").update({
                "WantToLearn" : selectedLanguage
              });
            }
            else if(selectedLanguage != args.message&&args.title=="Explain in"){
              await users.doc(FirebaseAuth.instance.currentUser.uid).update({
                "explain" : selectedLanguage
              });
            }
            return shouldPop;
          },
          child: /*ListView(
            children: countryList(country),
          ),*/
          FutureBuilder(
            future: asCountryList(country),
            builder: (context,snapshot){
              if(snapshot.hasData){
                return ListView(
                  children: snapshot.data,
                );
              }
              return Center(child: CircularProgressIndicator(),);
            },
          )
        ),
      ),
    );
  }
}
