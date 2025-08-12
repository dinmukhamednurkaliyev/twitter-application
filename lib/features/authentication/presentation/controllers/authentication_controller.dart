import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class AuthenticationController extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);

    final result = await getCurrentUserUseCase();

    return result.fold(
      (failure) {
        return null;
      },
      (user) => user,
    );
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    final signUpUseCase = ref.read(signUpUseCaseProvider);
    state = const AsyncLoading();
    final params = SignUpParams(
      email: email,
      username: username,
      password: password,
    );

    final result = await signUpUseCase(params);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (userEntity) {
        state = AsyncValue.data(userEntity);
      },
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final signInUseCase = ref.read(signInUseCaseProvider);
    state = const AsyncLoading();
    final params = SignInParams(email: email, password: password);

    final result = await signInUseCase(params);

    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (userEntity) => state = AsyncValue.data(userEntity),
    );
  }

  Future<void> signOut() async {
    final signOutUseCase = ref.read(signOutUseCaseProvider);
    state = const AsyncLoading();

    final result = await signOutUseCase();

    result.fold(
      (failure) {
        state = const AsyncValue.data(null);
      },
      (_) {
        state = const AsyncValue.data(null);
      },
    );
  }
}

final authenticationControllerProvider =
    AsyncNotifierProvider<AuthenticationController, UserEntity?>(() {
      return AuthenticationController();
    });
