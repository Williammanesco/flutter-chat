import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:m_chat/modules/auth/domain/entities/user.dart';
import 'package:m_chat/modules/auth/presentation/login_controller.dart';
import 'package:m_chat/modules/home/presenter/components/new_chat.dart';
import 'package:m_chat/shared/constants.dart';

import 'components/header_with_search_box.dart';
import 'components/personal_chats.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChatUser? user = Modular.get<LoginController>().chatUser;
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
      
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderWithSearchBox(size: size, name: user!.name),
            PersonalChats()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (context) => NewChat());
        },
        child: Icon(Icons.message),
        backgroundColor: kPrimaryColor,
        tooltip: 'Nova mensagem',
      ),
    );
  }
}