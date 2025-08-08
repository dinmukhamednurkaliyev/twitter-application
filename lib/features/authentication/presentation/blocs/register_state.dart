part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();
}

final class RegisterInitial extends RegisterState {
  const RegisterInitial();

  @override
  List<Object?> get props => [];
}

final class RegisterLoading extends RegisterState {
  const RegisterLoading();

  @override
  List<Object?> get props => [];
}

final class RegisterLoadingSuccess extends RegisterState {
  const RegisterLoadingSuccess();

  @override
  List<Object?> get props => [];
}

final class RegisterLoadingFailure extends RegisterState {
  const RegisterLoadingFailure({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
