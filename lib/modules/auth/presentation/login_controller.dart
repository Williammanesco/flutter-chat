import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:m_chat/modules/auth/domain/entities/user.dart';
import 'package:m_chat/modules/auth/domain/usecases/login_with_google.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginWithGoogle login;
  ChatUser? chatUser;

  LoginController(this.login);

  Future<void> executeLogin() async {
    var result = await login.login();
    
    if (result.isRight) {
      var firestore = FirebaseFirestore.instance;
      var ref = firestore.collection('users');
      var user = result.right();

      await ref
          .doc(user.uid)
          .set({'name': user.name, 'photo_url': user.photoUrl});

      chatUser = user;
      update();

      Modular.to.pushReplacementNamed('/home');
    }
  }
}