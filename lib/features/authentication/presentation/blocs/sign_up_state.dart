part of 'sign_up_bloc.dart';

sealed class SignUp extends Equatable {
  const SignUp();
}

final class SignUpInitial extends SignUp {
  const SignUpInitial();

  @override
  List<Object?> get props => [];
}

final class SignUpLoading extends SignUp {
  const SignUpLoading();

  @override
  List<Object?> get props => [];
}

final class SignInSuccess extends SignUp {
  const SignInSuccess();

  @override
  List<Object?> get props => [];
}

final class SignInFailure extends SignUp {
  const SignInFailure({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
