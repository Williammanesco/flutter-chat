import 'package:flutter_modular/flutter_modular.dart';
import 'package:m_chat/modules/auth/domain/usecases/login_with_google.dart';

class LoginController {
  LoginWithGoogle login;

  LoginController(this.login);

  Future<void> executeLogin() async {
    var result = await login.login();
    
    if (result.isRight) {
      Modular.to.pushReplacementNamed('/home');
    }
  }
}