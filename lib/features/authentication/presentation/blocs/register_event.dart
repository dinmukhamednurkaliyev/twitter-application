part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();
}

final class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted({
    required this.email,
    required this.username,
    required this.password,
  });

  final String email;
  final String username;
  final String password;

  @override
  List<Object> get props => [email, username, password];
}
