import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:m_chat/shared/constants.dart';

class NewChat extends StatefulWidget {
  NewChat({Key? key}) : super(key: key);

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  final Future<QuerySnapshot<Map<String, dynamic>>> usersReference =
      FirebaseFirestore.instance.collection('users').get();

  String search = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Nova conversa',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            onChanged: (value) {
              setState(() {
                search = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
              child: FutureBuilder(
                  future: usersReference,
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    List<QueryDocumentSnapshot<Map<String, dynamic>>> users =
                        [];
                    if (search.isNotEmpty) {
                      users = snapshot.data!.docs
                          .where((user) => user
                              .data()['name']
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                          .toList();
                    } else {
                      users = snapshot.data!.docs;
                    }

                    return _listAllUsers(users);
                  })),
        ],
      ),
    );
  }

  Widget _listAllUsers(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: docs.length,
      itemBuilder: (context, index) {
        return Column(children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(docs[index].data()['photo_url']),
            ),
            title: Text(docs[index].data()['name']),
            onTap: () {},
          ),
          Divider()
        ]);
      },
    );
  }
}
