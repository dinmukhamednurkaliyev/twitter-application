import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required RegisterUseCase registerUseCase,
  }) : _registerUseCase = registerUseCase,
       super(const RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }
  final RegisterUseCase _registerUseCase;

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());
    try {
      await _registerUseCase(
        email: event.email,
        username: event.username,
        password: event.password,
      );
      emit(const RegisterLoadingSuccess());
    } on Exception catch (exception) {
      emit(RegisterLoadingFailure(message: exception.toString()));
    }
  }
}
