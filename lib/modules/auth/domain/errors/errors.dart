abstract class Failure implements Exception {
  String get message;
}

class LoginError extends Failure {
  final String message;
  LoginError({required this.message});
}
