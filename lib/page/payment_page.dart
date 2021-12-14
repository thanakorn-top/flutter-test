import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:engbooster/actions/sign_in_actions.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class WebViewPayment extends StatefulWidget {
  @override
  _WebViewPaymentState createState() => _WebViewPaymentState();
}

class _WebViewPaymentState extends State<WebViewPayment> {
  // String filePath = 'html/test.html';
  WebViewController _webViewController;

  var price = "";
  void nextPage(BuildContext context) {
    updateCoursePrice(context, price);
  }

  var url = "";

  getUrl() {
    if (price == '3month') {
      url = 'http://192.168.2.220:18080/Omise_web/#/3month';
      // url = 'http://192.168.2.220/test1.html';
    } else if (price == '6month') {
      url = 'http://192.168.2.220:18080/Omise_web/#/6month';
      // url = 'http://192.168.2.220/test2.html';
    } else if (price == '12month') {
      url = 'http://192.168.2.220:18080/Omise_web/#/12month';
      // url = 'http://192.168.2.220/test3.html';
    }

    // url = 'http://192.168.2.220:18080/Omise_web/#/3month';
  }

  @override
  Widget build(BuildContext context) {
    price = ModalRoute.of(context).settings.arguments as String;
    getUrl();
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: WebView(
        debuggingEnabled: true,
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: Set.from([
          JavascriptChannel(
              name: 'Print',
              onMessageReceived: (JavascriptMessage message) {
                print("back to dart");
                //This is where you receive message from
                //javascript code and handle in Flutter/Dart
                //like here, the message is just being printed
                //in Run/LogCat window of android studio
                print(message.message);
                if (message.message == 'successful') {
                  nextPage(context);
                  // Navigator.pushReplacementNamed(context, '/mainMenuPage');
                } else {
                  Navigator.pushReplacementNamed(
                      context, '/selectPriceCoursePage');
                }
              })
        ]),
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          _webViewController.evaluateJavascript('fromFlutter("From Flutter")');
          // _loadHtmlFromAssets();
        },
      ),
    );
  }
  // _loadHtmlFromAssets() async{
  //   String fileHtmlContents = await rootBundle.loadString(filePath);
  //   _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
  //   mimeType:  'text/html',encoding: Encoding.getByName('utf-8')).toString());
  // }
}
