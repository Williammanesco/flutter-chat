import 'package:m_chat/modules/auth/domain/usecases/login_with_google.dart';

class LoginController {
  LoginWithGoogle login;

  LoginController(this.login);

  Future<bool> executeLogin() async {
    var result = await login.login();
    
    return result.isRight;
  }
}