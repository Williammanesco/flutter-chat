import 'package:flutter_modular/flutter_modular.dart';

import 'presentation/login_page.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/login', child: (context, args) => const LoginPage())
  ];
}