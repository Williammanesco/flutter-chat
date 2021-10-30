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
  String chatId;

  ChatList(
      {required this.photoUrl,
      required this.displayName,
      required this.lastMessageText,
      required this.lastMessageTime,
      required this.chatId});
}

class PersonalChats extends StatefulWidget {
  const PersonalChats({Key? key}) : super(key: key);

  @override
  State<PersonalChats> createState() => _PersonalChatsState();
}

class _PersonalChatsState extends State<PersonalChats> {
  ChatUser? user = Modular.get<LoginController>().chatUser;
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatsStream;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  _PersonalChatsState() {
    chatsStream = FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContainsAny: [user!.uid])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: chatsStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          var data = snapshot.data ?? null;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }

          List<Map<dynamic, dynamic>> usersChat = [];
          data!.docs.forEach((documentValue) {
            for (var userId in documentValue.get('users')) {
              if (userId != user!.uid)
                usersChat
                    .add({'userId': userId, 'documentId': documentValue.id});
            }
          });

          return FutureBuilder<List<ChatList>>(
              future: _buildChatInfo(usersChat),
              builder: (context, AsyncSnapshot<List<ChatList>> snapshot) {
                return _chatContainer(snapshot.data);
              });
        });
  }

  Future<List<ChatList>> _buildChatInfo(
      List<Map<dynamic, dynamic>> usersList) async {
    List<ChatList> chatList = [];
    for (var userId in usersList) {
      var snapshot = await users.doc(userId['userId']).get();

      if (snapshot.data() == null) {
        return chatList;
      }

      Map<String, dynamic> user = snapshot.data() as Map<String, dynamic>;

      chatList.add(ChatList(
          displayName: user['name'],
          lastMessageText: 'Teste',
          photoUrl: user['photo_url'],
          lastMessageTime: '20:00',
          chatId: userId['documentId'] ?? ''));
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
                          Modular.to.pushNamed(
                              '/home/chat?chatId=${chat.chatId}&name=${chat.displayName}');
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
