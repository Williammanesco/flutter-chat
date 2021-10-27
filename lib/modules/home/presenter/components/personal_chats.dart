import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:m_chat/modules/auth/domain/entities/user.dart';
import 'package:m_chat/modules/auth/presentation/login_controller.dart';

class ChatList {
  String photoUrl;
  String displayName;
  String lastMessageText;
  String lastMessageTime;

  ChatList(
      {required this.photoUrl,
      required this.displayName,
      required this.lastMessageText,
      required this.lastMessageTime});
}

class PersonalChats extends StatefulWidget {
  const PersonalChats({Key? key}) : super(key: key);

  @override
  State<PersonalChats> createState() => _PersonalChatsState();
}

class _PersonalChatsState extends State<PersonalChats> {
  ChatUser? user = Modular.get<LoginController>().chatUser;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? documentStream;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  _PersonalChatsState() {
    documentStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(user!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: documentStream,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          var data = snapshot.data?.data() ?? null;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }

          return FutureBuilder<List<ChatList>>(
              future: _buildChatInfo(data),
              builder: (context, AsyncSnapshot<List<ChatList>> snapshot) {
                return _chatContainer(snapshot.data);
              });
        });
  }

  Future<List<ChatList>> _buildChatInfo(Map<String, dynamic>? data) async {
    List<ChatList> chatList = [];
    if (data != null) {
      for (var entry in data.entries) {
        var snapshot = await users.doc(entry.key).get();

        if (snapshot.data() == null) {
          return chatList;
        }

        Map<String, dynamic> user = snapshot.data() as Map<String, dynamic>;

        chatList.add(ChatList(
            displayName: user['name'],
            lastMessageText: 'Teste',
            photoUrl: user['photo_url'],
            lastMessageTime: '20:00'));
      }
    }

    return chatList;
  }

  Widget _chatContainer(List<ChatList>? chatList) {
    if (chatList == null)
      return Center(
        child: Text('Sem conversas...'),
      );
      
    return Container(
            child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Align(
              child: Text(
                'Suas mensagens',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.topLeft,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  scrollDirection: Axis.vertical,
                        children: chatList.map((chat) {
                    return GestureDetector(
                        child: _cardChat(chat),
                        onTap: () {
                          Modular.to.pushNamed('/home/chat');
                       });
                  }).toList(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardChat(ChatList chat) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipOval(
                    child: Image.network(
                      chat.photoUrl,
                      width: 40,
                      height: 40,
                      alignment: Alignment.topLeft,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(chat.displayName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(chat.lastMessageText),
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(chat.lastMessageTime),
                ),
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}


