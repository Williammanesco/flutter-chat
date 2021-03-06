import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:m_chat/modules/auth/domain/entities/user.dart';
import 'package:m_chat/modules/auth/presentation/login_controller.dart';
import 'package:m_chat/shared/constants.dart';

class ChatPage extends StatefulWidget {
  final String? uidChatUser;
  final String? name;
  final String? chatId;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? chatStream;
  ChatUser? user = Modular.get<LoginController>().chatUser;

  ChatPage({Key? key, this.uidChatUser, this.name, this.chatId})
      : super(key: key) {
    chatStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .snapshots();
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String messageText = '';

  TextEditingController? _controller;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: messageText);
    _scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name ?? ''),
          backgroundColor: kPrimaryColor,
        ),
        resizeToAvoidBottomInset: true,
        body: _chatContainer(context));
  }

  Widget _streamMessages() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: widget.chatStream,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          List<dynamic>? messages = snapshot.data?.get('messages') ?? null;

          if (messages == null || messages.length == 0)
            return Center(child: Text("Inicie uma conversa"));

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Carregando..."));
          }

          var newMessages = List.from(messages.reversed);

          return ListView.builder(
            controller: _scrollController,
            itemCount: newMessages.length,
            dragStartBehavior: DragStartBehavior.down,
            reverse: true,
            itemBuilder: (_, index) {
              var message = newMessages[index];

              if (message['from'] != widget.user?.uid) {
                return _leftMessage(message['message']);
              } else {
                return _rightMessage(message['message']);
              }
            },
          );
        });
  }

  Widget _chatContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _streamMessages(),
        )),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      messageText = value;
                    });
                  },
                  controller: _controller,
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
              onPressed: () async {
                print(widget.chatId);
                await FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatId)
                    .update({
                  'messages': FieldValue.arrayUnion([
                    {
                      'from': widget.user!.uid,
                      'message': messageText,
                      'timestamp': DateTime.now().millisecondsSinceEpoch
                    }
                  ])
                });

                _controller!.clear();
                if (_scrollController != null) {
                  _scrollController!.jumpTo(0);
                } 
              },
            )
          ],
        ),
      ]),
    );
  }

  Widget _rightMessage(String message) {
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
                  child: Text(message,
                      style: TextStyle(fontSize: 16.0, color: Colors.white))))),
    );
  }

  Widget _leftMessage(String message) {
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
                  child: Text(message,
                      style: TextStyle(fontSize: 16.0, color: Colors.white))))),
    );
  }
}
