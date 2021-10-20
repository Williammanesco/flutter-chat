import 'package:either_dart/either.dart';
import 'package:m_chat/modules/auth/domain/entities/user.dart';
import 'package:m_chat/modules/auth/domain/errors/errors.dart';

abstract class LoginWithGoogle {
  Future<Either<Failure, ChatUser>> login();
}