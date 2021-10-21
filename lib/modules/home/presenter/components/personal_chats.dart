import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
class PersonalChats extends StatelessWidget {
  const PersonalChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('passa');

    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    // var ref = firestore.collection('chat1');
    // ref.add({'aa': 'teste_doc'});

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
                  children: [
                    GestureDetector(
                      child: _cardChat(),
                      onTap: () {
                        Modular.to.pushNamed('/home/chat');
                      },
                    ),
                    _cardChat(),
                    _cardChat(),
                    _cardChat(),
                    _cardChat(),
                    _cardChat(),
                    _cardChat(),
                    _cardChat(),
                    _cardChat(),
                    _cardChat(),
                    _cardChat(),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardChat() {
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
                      'https://scontent.fmgf7-1.fna.fbcdn.net/v/t1.6435-9/46482389_2264750926909313_8004761326737948672_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=09cbfe&_nc_eui2=AeFF4vV2fpSgQ_1euFze8GVZS34pWqhasQpLfilaqFqxCjTJ8yHXN9jAxPM4cYEm1pD1L-ctl-pdIu-ruGY6FdZe&_nc_ohc=q_DL1IV97hEAX-oA9Nm&_nc_ht=scontent.fmgf7-1.fna&oh=6cc3802f7e294c68734b64e9b10bb8ac&oe=6196786D',
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
                      child: Text('Alini',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Alini: te amo'),
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('20:00'),
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
