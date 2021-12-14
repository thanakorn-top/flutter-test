import 'package:flutter/material.dart';
import 'package:engbooster/model/radio_model.dart';

class SelectLevelPage extends StatefulWidget {
  @override
  createState() {
    return new SelectLevelPageState();
  }
}

class SelectLevelPageState extends State<SelectLevelPage> {
  List<int> _selectedItems = List<int>();
  List<RadioModel> sampleData = new List<RadioModel>();
  bool isBtnDisable = true;
  Map args = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add(new RadioModel(
        "assets/images/pic1.jpg", 'Learn the basic', 'Elementary'));
    sampleData.add(new RadioModel(
        "assets/images/pic2.jpg", 'Upgrade your skill', 'Intermediate'));
    sampleData.add(new RadioModel(
        "assets/images/pic3.jpg", 'Polish off your knowledge', 'Advance'));
  }

  void nextPage() {
    int idx = _selectedItems[0];
    RadioModel data = sampleData[idx];
    args['level'] = data.text;
    Navigator.pushNamed(context, '/saveProgressLoginPage', arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as Map;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
              leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
             Navigator.pushNamed(context, '/welcomePage', arguments: args);
            // Navigator.pushNamed(context, '/welcomePage');
            // do something
          },
        ),

      ),
      body: Column(
        children: [
          Padding(
            padding: new EdgeInsets.only(
              left: 15.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Choose You Level",
                style:
                    new TextStyle(fontWeight: FontWeight.w500, fontSize: 25.0),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Center(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: new EdgeInsets.all(10.0),
                  padding: new EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      border: (_selectedItems.contains(index))
                          ? Border.all(color: Colors.white)
                          : Border.all(color: Colors.black),
                      color: (_selectedItems.contains(index))
                          ? Colors.blue.withOpacity(0.5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      )),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          if (_selectedItems.contains(index)) {
                            setState(() {
                              _selectedItems.removeWhere((val) => val == index);
                              isBtnDisable = true;
                            });
                          } else {
                            setState(() {
                              _selectedItems = List<int>();
                              _selectedItems.add(index);
                              isBtnDisable = false;
                            });
                          }
                        },
                        leading: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 44,
                            minHeight: 44,
                            maxWidth: 64,
                            maxHeight: 64,
                          ),
                          child: Image.asset(sampleData[index].pic,
                              fit: BoxFit.cover),
                        ),
                        // leading: Image.asset(sampleData[index].pic),
                        title: new Center(
                            child: new Text(
                          sampleData[index].text,
                          // "Centered Title#$index"
                          style: new TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 25.0),
                        )),
                        subtitle: new Center(
                            child: new Text(
                          sampleData[index].buttonText,
                          // "Centered Title#$index"
                          style: new TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15.0),
                        )),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: Opacity(
                opacity: isBtnDisable ? 0.7 : 1.0,
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
                  onPressed: isBtnDisable ? null : nextPage,
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
