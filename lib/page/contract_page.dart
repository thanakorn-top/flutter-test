import 'package:flutter/material.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({Key key}) : super(key: key);

  @override
  _ContractPageState createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  TextEditingController sendText = TextEditingController();

  _senderChatBox(String chatText){
    return Container(
      alignment: Alignment.topRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
            color:  Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ]
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Text(chatText),
      ),
    );
  }

  _receiverChatBox(String chatText){
    return Container(
      alignment: Alignment.topLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
            color:  Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ]
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Text(chatText),
      ),
    );
  }

  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.attach_file),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: sendText,
              decoration: InputDecoration.collapsed(
                hintText: 'Enter a message',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contract us"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      _senderChatBox("Hello"),
                      _receiverChatBox("Hi, How are you?"),
                      _senderChatBox("I'm fine"),
                      _senderChatBox("asdsadsadsadadsadajdjoaijdioajdoiajsoidjsad")
                    ],
                  ),
                ],
              ),
            ),
          ),
          _sendMessageArea()
        ],
      ),
    );
  }
}

