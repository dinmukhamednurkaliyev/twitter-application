import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class SignInUseCase {
  const SignInUseCase({required this.authenticationRepository});
  final AuthenticationRepository authenticationRepository;

  Future<UserEntity> call(SignInParams params) async {
    return authenticationRepository.signIn(params: params);
  }
}

@immutable
class SignInParams extends Equatable {
  const SignInParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  List<Object?> get props => [email, password];
}
