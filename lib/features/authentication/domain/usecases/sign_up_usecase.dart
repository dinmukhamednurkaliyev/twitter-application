import 'package:equatable/equatable.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class SignUpUseCase {
  const SignUpUseCase({required this.authenticationRepository});
  final AuthenticationRepository authenticationRepository;

  Future<UserEntity> call(SignUpParams params) async {
    return authenticationRepository.signUp(params: params);
  }
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.username,
    required this.password,
  });

  final String email;
  final String username;
  final String password;

  Map<String, dynamic> toJson() => {
    'email': email,
    'username': username,
    'password': password,
  };

  @override
  List<Object?> get props => [email, username, password];
}
