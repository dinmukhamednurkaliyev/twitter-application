import 'package:twitter_application/features/authentication/authentication.dart';

class RegisterUseCase {
  const RegisterUseCase({required this.authenticationRepository});
  final AuthenticationRepository authenticationRepository;

  Future<String> call({
    required String email,
    required String username,
    required String password,
  }) async {
    final user = UserEntity(
      email: email,
      username: username,
      password: password,
    );
    final token = await authenticationRepository.register(user: user);
    return token;
  }
}
