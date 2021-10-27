import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:m_chat/modules/auth/domain/entities/user.dart';
import 'package:m_chat/modules/auth/presentation/login_controller.dart';
import 'package:m_chat/shared/constants.dart';

class ChatPage extends StatefulWidget {
  final String? uidChatUser;
  final String? name;

  Stream<DocumentSnapshot<Map<String, dynamic>>>? chatStream;
  ChatUser? user = Modular.get<LoginController>().chatUser;

  ChatPage({Key? key, this.uidChatUser, this.name}) : super(key: key) {
    chatStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(user!.uid)
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
    //  _scrollController = new ScrollController(
    //     initialScrollOffset: _scrollController?.position.maxScrollExtent);
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
          var data = snapshot.data?.data() ?? null;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }

          if (data == null || data.length == 0)
            return Center(child: Text("Inicie uma conversa"));

          List<dynamic> messages = new Map.fromIterable(
              data.keys.where((k) => k == widget.uidChatUser),
              key: (k) => k,
              value: (k) => data[k])[widget.uidChatUser];

          return ListView(
            controller: _scrollController,
            children: [
              Column(
                  children: messages.map((message) {
                if (message['from'] == widget.uidChatUser)
                  return _leftMessage(message['message']);
                return _rightMessage(message['message']);
              }).toList())
            ],
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
                await FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.user!.uid)
                    .update({
                  '${widget.uidChatUser}': FieldValue.arrayUnion([
                    {
                      'from': widget.user!.uid,
                      'message': messageText,
                      'timestamp': DateTime.now().millisecondsSinceEpoch
                    }
                  ])
                });

                _controller!.clear();
                if (_scrollController != null) {
                  _scrollController!
                      .jumpTo(_scrollController!.position.maxScrollExtent);
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
