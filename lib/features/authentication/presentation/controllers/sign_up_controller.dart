// features/authentication/notifiers/sign_up_notifier.dart

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class SignUpController extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() {
    return null;
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    final signUpUseCase = ref.read(signUpUseCaseProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => signUpUseCase(
        email: email,
        username: username,
        password: password,
      ),
    );
  }
}

final signUpControllerProvider =
    AsyncNotifierProvider<SignUpController, String?>(() {
      return SignUpController();
    });
