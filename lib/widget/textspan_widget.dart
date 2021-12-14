import 'package:engbooster/widget/content_detail_word_widget.dart';
import 'package:flutter/material.dart';

class TextSpanWidget extends StatefulWidget {
  final List exampleList;

  TextSpanWidget({this.exampleList});

  @override
  _TextSpanWidgetState createState() => _TextSpanWidgetState();
}

class _TextSpanWidgetState extends State<TextSpanWidget>  {
  List<Widget> example = [];
  @override
  void initState() {
    super.initState();
    initExample();
  }

  initExample(){
    for(int i =0; i < widget.exampleList.length;i++){
      example.add(WordWidget(exampleList: widget.exampleList[i],));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 10,right: 15, left: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 4,
          runSpacing: 4.0, // gap between lines
          children: example
        ),
      ),
    );
  }
}


class WordWidget extends StatefulWidget {
  final Map exampleList;

  WordWidget({ this.exampleList});
  @override
  _WordWidgetState createState() => _WordWidgetState();
}

class _WordWidgetState extends State<WordWidget>  {

  GlobalKey _key = GlobalKey();
  double _x, _y;
  bool _highlight = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      key: _key,
      child: Text(
        widget.exampleList["word"],
        style: TextStyle(
            backgroundColor: _highlight
                ? Colors.purple.shade200
                : Colors.transparent,
            fontSize: _highlight ? 19 : 18,
            fontWeight: _highlight
                ? FontWeight.w600
                : FontWeight.normal,
            color: Colors.black87),
      ),
      onTap: () async {
        setState(() {
          _highlight = true;
        });
        RenderBox box =
        _key.currentContext.findRenderObject();
        Offset position =
        box.localToGlobal(Offset.zero);
        Size sizeRichText = box.size;
        _x = position.dx;
        _y = position.dy + sizeRichText.height;
        await showDialog<String>(
            context: context,
            barrierColor: Color(0x01000000),
            builder: (_) {
              return ContentDetailWordWidget(
                x: _x,
                y: _y,
                size: size,
                vocab: widget.exampleList["word"],
                structure: widget.exampleList["type_structure"],
                meaning: widget.exampleList["meaning"],
              );
            });
        setState(() {
          _highlight = false;
        });
        // _showDetail(_key, size);
      },
    );
  }
}