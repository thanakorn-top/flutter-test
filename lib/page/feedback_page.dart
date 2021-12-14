import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("My Feedbacks"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Text("Conversation in this app will appear here."),
                SizedBox(height: 10,),
                ElevatedButton(
                  child: Text("Start conversation"),
                  onPressed: (){
                    Navigator.pushNamed(context, '/contractPage');
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
