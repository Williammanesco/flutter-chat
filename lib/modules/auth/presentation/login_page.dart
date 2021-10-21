import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:m_chat/modules/auth/presentation/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<LoginController>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'MChat',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 60.0,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 25,
                ),
               
                Divider(
                  color: Colors.black,
                  height: 30,
                ),

                ElevatedButton(
                    child: const Text('LOGIN COM GOOGLE'),
                    onPressed: () => controller.executeLogin())
              ],
            ),
          ),
        ),
      ),
    );
  }
}