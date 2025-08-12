import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:twitter_application/core/core.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class SignUpUseCase {
  const SignUpUseCase({required this.repository});
  final AuthenticationRepository repository;

  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    return repository.signUp(params: params);
  }
}

@immutable
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
