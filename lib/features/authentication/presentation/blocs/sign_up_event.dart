part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();
}

final class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted({
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
