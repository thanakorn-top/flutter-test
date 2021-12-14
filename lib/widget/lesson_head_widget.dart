import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class LessonHeadWidget extends StatelessWidget {

  final String  title;
  final String  detail;
  final String  imgPath;

  LessonHeadWidget({this.title, this.detail, this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.only(bottom: 35.0, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: imgPath,
                width: 80,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                child: Text(
                  detail,
                  style: TextStyle(
                      fontWeight: FontWeight.w500),
                ),
                width: 120,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
