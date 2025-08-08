import 'package:twitter_application/features/authentication/authentication.dart';

interface class AuthenticationRepository {
  const AuthenticationRepository();
  Future<String> register({
    required UserEntity user,
  }) {
    throw UnimplementedError('register() has not been implemented yet.');
  }
}
