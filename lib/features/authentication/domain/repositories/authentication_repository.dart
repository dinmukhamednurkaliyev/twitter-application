import 'package:twitter_application/features/authentication/authentication.dart';

interface class AuthenticationRepository {
  const AuthenticationRepository();
  Future<String> signUp({
    required UserEntity user,
  }) {
    throw UnimplementedError('register() has not been implemented yet.');
  }

  Future<String> signIn({
    required UserEntity user,
  }) {
    throw UnimplementedError('register() has not been implemented yet.');
  }
}
