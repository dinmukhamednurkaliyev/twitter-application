import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class AuthenticationController extends AsyncNotifier<UserEntity?> {
  @override
  FutureOr<UserEntity?> build() {
    return null;
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

    state = await AsyncValue.guard(() => signUpUseCase(params));
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final signInUseCase = ref.read(signInUseCaseProvider);
    state = const AsyncLoading();
    final params = SignInParams(email: email, password: password);

    state = await AsyncValue.guard(() async => signInUseCase(params));
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = const AsyncData(null);
  }
}

final authenticationControllerProvider =
    AsyncNotifierProvider<AuthenticationController, UserEntity?>(() {
      return AuthenticationController();
    });
