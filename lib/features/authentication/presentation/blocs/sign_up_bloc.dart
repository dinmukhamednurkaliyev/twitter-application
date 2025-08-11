import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUp> {
  SignUpBloc({
    required SignUpUseCase registerUseCase,
  }) : _registerUseCase = registerUseCase,
       super(const SignUpInitial()) {
    on<SignUpSubmitted>(_onRegisterSubmitted);
  }
  final SignUpUseCase _registerUseCase;

  Future<void> _onRegisterSubmitted(
    SignUpSubmitted event,
    Emitter<SignUp> emit,
  ) async {
    emit(const SignUpLoading());
    try {
      await _registerUseCase(
        email: event.email,
        username: event.username,
        password: event.password,
      );
      emit(const SignInSuccess());
    } on Exception catch (exception) {
      emit(SignInFailure(message: exception.toString()));
    }
  }
}
