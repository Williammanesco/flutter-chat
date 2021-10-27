import 'package:either_dart/either.dart';
import 'package:m_chat/modules/auth/data/protocols/login_with_google_repository.dart';
import 'package:m_chat/modules/auth/domain/errors/errors.dart';
import 'package:m_chat/modules/auth/domain/entities/user.dart';
import 'package:m_chat/modules/auth/domain/usecases/login_with_google.dart';

class LoginWithGoogleService implements LoginWithGoogle {

  LoginWithGoogleRepository repository; 

  LoginWithGoogleService(this.repository);

  @override
  Future<Either<Failure, ChatUser>> login() async {
    var result = await repository.login();

    if (result.isLeft) {
      return Left(LoginError(message: 'Falha no login'));
    }

    return Right(result.right());
  }

}