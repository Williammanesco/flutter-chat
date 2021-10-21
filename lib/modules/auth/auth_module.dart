import 'package:flutter_modular/flutter_modular.dart';
import 'package:m_chat/modules/auth/data/services/login_with_google.dart';
import 'package:m_chat/modules/auth/infra/firebase/login_with_google.dart';
import 'package:m_chat/modules/auth/presentation/login_controller.dart';
import 'package:m_chat/modules/auth/presentation/login_page.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory((i) => FirebaseLoginWithGoogle()),
        Bind.factory((i) => LoginWithGoogleService(i())),
        Bind.singleton<LoginController>((i) => LoginController(i())),
      ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/login', child: (context, args) => const LoginPage())
  ];
}