import 'package:flutter/material.dart';

class LevelToLearnWidget extends StatelessWidget {
  final String levelText;

  LevelToLearnWidget({this.levelText});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            levelText,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
