import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_application/features/authentication/presentation/controllers/authentication_controller.dart';

@immutable
class SignInFormState {
  const SignInFormState({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    this.isPasswordVisible = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;

  SignInFormState copyWith({
    bool? isPasswordVisible,
  }) {
    return SignInFormState(
      formKey: formKey,
      emailController: emailController,
      passwordController: passwordController,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}

class SignInFormNotifier extends StateNotifier<SignInFormState> {
  SignInFormNotifier(this._ref)
    : super(
        SignInFormState(
          formKey: GlobalKey<FormState>(),
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
        ),
      );
  final Ref _ref;

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void submitSignIn() {
    if (state.formKey.currentState?.validate() != true) {
      return;
    }

    final email = state.emailController.text.trim();
    final password = state.passwordController.text.trim();

    _ref
        .read(authenticationControllerProvider.notifier)
        .signIn(
          email: email,
          password: password,
        );
  }

  @override
  void dispose() {
    state.emailController.dispose();
    state.passwordController.dispose();
    super.dispose();
  }
}

final AutoDisposeStateNotifierProvider<SignInFormNotifier, SignInFormState>
signInFormNotifierProvider =
    StateNotifierProvider.autoDispose<SignInFormNotifier, SignInFormState>(
      SignInFormNotifier.new,
    );
