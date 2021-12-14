import 'package:flutter/material.dart';

class PaddingBox extends StatelessWidget {
  final String title;

  PaddingBox(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Align(
          alignment: Alignment.topLeft,
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.star, size: 20,color: Colors.redAccent,),
                ),
                TextSpan(
                  text: title,
                  style: new TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18.0,color: Colors.black),
                ),
              ],
            ),
          )

          // Text(
          //   title,
          //   style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
          // ),
          ),
    );
  }
}
