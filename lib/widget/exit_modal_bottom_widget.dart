import 'package:flutter/material.dart';

class ExitModalBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40 ,horizontal: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Quit",style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),),
          SizedBox(height: 20,),
          Container(child: Text("Are you sure you want to quit learning?\nAll progress will be lost",textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500))),
          SizedBox(height: 40,),
          Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.transparent)),
            child: Material(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(child: Text("yes",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.white),)),
                onTap: () {
                  Navigator.pop(context,true);
                },
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.deepPurple)),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(child: Text("no, continue learning",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.deepPurple),)),
                onTap: () {
                  Navigator.pop(context,false);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
