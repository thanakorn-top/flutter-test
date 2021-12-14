import 'package:flutter/material.dart';

class CourseBox extends StatelessWidget {
  final String title;
  final bool click;
  final String month;
  final String price;

  CourseBox(this.title, this.click, this.month, this.price);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: (click)
              ? Border.all(color: Colors.white)
              : Border.all(color: Colors.black),
          color: (click) ? Colors.blue.withOpacity(0.5) : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          )),
      height: 130,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "$month month",
              style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
            ),
            Text("$price USD",
              style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 10.0),
              ),
          ],
        )),
      ),
    );
  }
}
