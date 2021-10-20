
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:m_chat/modules/auth/data/protocols/login_with_google_repository.dart';
import 'package:m_chat/modules/auth/domain/errors/errors.dart';
import 'package:m_chat/modules/auth/domain/entities/user.dart';

class FirebaseLoginWithGoogle implements LoginWithGoogleRepository {
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    // if (user != null) {
    //   Modular.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) => UserInfoScreen(
    //         user: user,
    //       ),
    //     ),
    //   );
    // }

    return firebaseApp;
  }

  @override
  Future<Either<Failure, ChatUser>> login() async {
    User? user = await _signInWithGoogle();

    if (user != null) {
      return Right(new ChatUser(name: user.displayName ?? 'Indefinido', email:  user.email ?? 'Indefinido'));
    } else {
      return Left(LoginError(message: 'Erro ao logar com google.'));
    }
  }

  static Future<User?> _signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }

    return user;
  }

}
