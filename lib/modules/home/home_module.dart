import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:m_chat/modules/auth/presentation/login_controller.dart';
import 'package:m_chat/modules/home/presenter/chat_page.dart';
import 'package:m_chat/modules/home/presenter/home_page.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<LoginController>((i) => Get.find<LoginController>()),
      ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => HomePage()),
    ChildRoute('/chat',
            child: (context, args) => ChatPage(
                  chatId: args.queryParams['chatId'],
                  name: args.queryParams['name'],
                )),
  ];
}