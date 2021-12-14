import 'package:flutter/material.dart';
import 'package:engbooster/model/radio_model.dart';

class WelcomePage extends StatefulWidget {
  @override
  createState() {
    return new WelcomePageState();
  }
}

class WelcomePageState extends State<WelcomePage> {
  List<int> _selectedItems = List<int>();
  List<RadioModel> sampleData = new List<RadioModel>();
  bool isBtnDisable = true;
  Map args = {};
  void nextPage() {
    // int idx = _selectedItems[0];
    // RadioModel data = sampleData[idx];
    
    Navigator.pushNamed(context, '/selectLevelPage',arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as Map;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
                leading:        
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/selectCourseFirstPage');
              // do something
            },
          ),
      ),
      body: Column(
        children: [
          Padding(
            padding: new EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Develop Your English Vocabulary Easily",
                style:
                    new TextStyle(fontWeight: FontWeight.w500, fontSize: 25.0),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: new EdgeInsets.all(
              15.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Simple lessons with all explantions in English",
                style:
                    new TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Stack(
            fit: StackFit.passthrough,
            // clipBehavior: Clib.visible,
            children: <Widget>[
              // Max Size Widget
              Container(
                height: 300,
                width: 400,
                // color: Colors.green,
                child: Center(child: Image.asset("assets/images/pic6.png")),
              ),

              Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    height: 150,
                    width: 200,
                    // color: Colors.orange,
                    child: Center(child: Image.asset("assets/images/pic5.png")),
                  )),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: Opacity(
                opacity: 1.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      onPrimary: Colors.white,
                      minimumSize: Size(400, 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: Text(
                    "Next",
                    style: new TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 25.0),
                  ),
                  onPressed: nextPage,
                  // onPressed: () {
                  //   Navigator.pushNamed(context, '/saveProgressLoginPage');
                  //   // do something
                  // },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class RadioModel {
//   final String pic;
//   final String buttonText;
//   final String text;
//   RadioModel(this.pic, this.buttonText, this.text);
// }
