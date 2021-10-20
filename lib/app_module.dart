import 'package:flutter_modular/flutter_modular.dart';
import 'package:m_chat/modules/home/home_module.dart';
import 'package:m_chat/splash_page.dart';

import 'modules/auth/auth_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => SplashPage()),
    ModuleRoute('/auth', module: AuthModule()),
    ModuleRoute('/home', module: HomeModule()),
  ];
}