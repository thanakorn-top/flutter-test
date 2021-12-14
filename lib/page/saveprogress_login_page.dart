import 'package:flutter/material.dart';
import 'package:engbooster/actions/sign_in_actions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:engbooster/model/radio_model.dart';
// import 'package:engbooster/page/select_level_page.dart';

class SaveProgressLoginPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SaveProgressLoginPageState createState() => _SaveProgressLoginPageState();
}

class _SaveProgressLoginPageState extends State<SaveProgressLoginPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;
    // print(args.buttonText);
    // print(args.pic);
    // print(args.text);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Here we take the value from the SaveProgressLoginPage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
             Navigator.pushNamed(context, '/selectLevelPage',arguments: args);
            // Navigator.pushNamed(context, '/selectLevelPage');
            // do something
          },
        ),

        // leading: BackButton(),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.close,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/settingPage');
        //       // do something
        //     },
        //   )
        // ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Save Your progress",
                    style: new TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 25.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "You now need a profile to save",
                    style: new TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "you progress",
                    style: new TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
                  child: Image.asset("assets/images/pic4.jpg"),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: MaterialButton(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                elevation: 0,
                                minWidth: double.maxFinite,
                                height: 50,
                                onPressed: () {
                                  signInWithGoogle(context, args);
                                  //Here goes the logic for Google SignIn discussed in the next section
                                },
                                color: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.google),
                                    SizedBox(width: 10),
                                    Text('Sign-in using Google',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ],
                                ),
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        )),
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: MaterialButton(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                elevation: 0,
                                minWidth: double.maxFinite,
                                height: 50,
                                onPressed: () {
                                  signInWithFacebook(context, args);
                                  //Here goes the logic for Google SignIn discussed in the next section
                                },
                                color: Colors.blue,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(FontAwesomeIcons.facebook),
                                    SizedBox(width: 10),
                                    Text('Sign-in using Facebook',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ],
                                ),
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
