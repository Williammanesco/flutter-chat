import 'package:flutter/material.dart';
import 'package:m_chat/shared/constants.dart';
import 'package:m_chat/shared/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alini'),
        backgroundColor: kPrimaryColor,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _chatHistory(),
          )),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        hintText: 'Digite sua mensagem aqui'),
                  ),
                ),
              ),
              TextButton.icon(
                label: Text(''),
                icon: Icon(Icons.send),
                onPressed: () {},
              )
            ],
          ),
        ]),
      ),
    );
  }

  Widget _chatHistory() {
    return Column(
      children: [_rightMessage(), _leftMessage(), _rightMessage()],
    );
  }

  Widget _rightMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.topRight,
          child: Container(
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  border: Border.all(color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("post 1",
                      style: TextStyle(fontSize: 16.0, color: Colors.white))))),
    );
  }

  Widget _leftMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.topLeft,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      "post 1asdjaosidjaoidjaodsiajodiajdsoiajdaoasdaoidjaoidsjaoidjadoiadi",
                      style: TextStyle(fontSize: 16.0, color: Colors.white))))),
    );
  }
}
