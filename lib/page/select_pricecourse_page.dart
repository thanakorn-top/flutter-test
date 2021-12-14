import 'package:engbooster/actions/sign_in_actions.dart';
import 'package:flutter/material.dart';
import 'package:engbooster/widget/padding_box.dart';
import 'package:engbooster/widget/course_price_box.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SelectPriceCoursePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _SelectPriceCoursePageState createState() => _SelectPriceCoursePageState();
}

class _SelectPriceCoursePageState extends State<SelectPriceCoursePage> {
  var _selectedItems = [];

//Merchant's account information
  String merchant_id = 'JT01'; //Get MerchantID when opening account with 2C2P
  String secret_key = '7jYcp4FxFdf0'; //Get SecretKey from 2C2P PGW Dashboard

  //Transaction information
  String payment_description = '2 days 1 night hotel room';
  var today = new DateTime.now();
  // var order_id_string = order_id.toString();
  String currency = '702';
  String amount = '000000002500';

  // Printing concated result
  // by the use of '+' operator
  //Request information
  String version = '8.5';
  String payment_url = 'https://demo2.2c2p.com/2C2PFrontEnd/RedirectV3/payment';
  String result_url_1 =
      'http://localhost/devPortal/V3_UI_PHP_JT01_devPortal/result.php';

  //Construct signature string
  // var param = '$version$merchant_id';

  //  List<String> _selectedItems = List<String>();
  Map args = {};
  // void nextPage() {
  //   updateCoursePrice(context, _selectedItems[0]);
  // }

  void nextPage() {
    String price = _selectedItems[0];
    Navigator.pushNamed(context, '/paymentPage', arguments: price);
  }

  // Future api() async {
  //   String dateSlug =
  //       "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

  //   // String params = version +
  //   //     merchant_id +
  //   //     payment_description +
  //   //     dateSlug +
  //   //     currency +
  //   //     amount +
  //   //     result_url_1;

  //   String params =
  //       "8.5JT012 days 1 night hotel room1624434441702000000002500http://localhost/devPortal/V3_UI_PHP_JT01_devPortal/result.php";

  //   var key = utf8.encode('7jYcp4FxFdf0');
  //   var bytes = utf8.encode(params);
  //   var hmacSha256 = new Hmac(sha256, key);
  //   Digest digest = hmacSha256.convert(bytes);
  //   String digestSt = digest.toString();
  //   print(digest);

  //   // var hash_value = hash_hmac('sha256',params, secret_key,false);	//Compute hash value

  //   // String apiUrl = "https://demo2.2c2p.com/2C2PFrontEnd/RedirectV3/payment";
  //   // final response = await http.post(Uri.parse(apiUrl), body: {
  //   //   "hash_value": digestSt,
  //   //   "version": "8.5",
  //   //   "merchant_id": "JT01",
  //   //   "currency": "702",
  //   //   "result_url_1":
  //   //       "http://localhost/devPortal/V3_UI_PHP_JT01_devPortal/result.php",
  //   //   "payment_description": "2 days 1 night hotel room",
  //   //   "order_id": "1624434441",
  //   //   "amount": "000000002500",
  //   //   "submit": "Confirm",
  //   // });

  //   // print(response.statusCode);
  // }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as Map;
    print(args);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Here we take the value from the SelectPriceCoursePage object that was created by
        // the App.build method, and use it to set our appbar title.

        // leading: BackButton(),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: new EdgeInsets.only(
                  left: 15.0,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Unlock All Language Course",
                    style: new TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 25.0),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Column(
                  children: [
                    PaddingBox(" Improve speaking in 15 minute a day"),
                    PaddingBox(
                        ' Learn through playing and "Fast brain" approach'),
                    PaddingBox(
                        " 2000 + words with illustration and explanations"),
                    PaddingBox(" Daily Study Plan & Weekly Goal tracking"),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (_selectedItems.contains("3month")) {
                              setState(() {
                                _selectedItems = [];
                              });
                            } else {
                              setState(() {
                                _selectedItems = [];
                                _selectedItems.add("3month");
                              });
                              // api();
                            }
                          },
                          child: CourseBox("Text 01",
                              _selectedItems.contains("3month"), "3", "4"),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_selectedItems.contains("6month")) {
                              setState(() {
                                _selectedItems = [];
                              });
                            } else {
                              setState(() {
                                _selectedItems = [];
                                _selectedItems.add("6month");
                              });
                            }
                          },
                          child: CourseBox("Text 02",
                              _selectedItems.contains("6month"), "6", "6"),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_selectedItems.contains("12month")) {
                              setState(() {
                                _selectedItems = [];
                              });
                            } else {
                              setState(() {
                                _selectedItems = [];
                                _selectedItems.add("12month");
                              });
                            }
                          },
                          child: CourseBox("Text 03",
                              _selectedItems.contains("12month"), "12", "10"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  child: Opacity(
                    opacity: _selectedItems.isEmpty ? 0.7 : 1.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          onPrimary: Colors.white,
                          minimumSize: Size(400, 80),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      child: Text(
                        "Purchase",
                        style: new TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 25.0),
                      ),
                      // onPressed: isBtnDisable ? null : nextPage,
                      onPressed: _selectedItems.isEmpty ? null : nextPage,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
