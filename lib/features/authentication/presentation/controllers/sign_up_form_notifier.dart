import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_application/features/authentication/presentation/controllers/authentication_controller.dart';

@immutable
class SignUpFormState {
  const SignUpFormState({
    required this.formKey,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    this.isPasswordVisible = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;

  SignUpFormState copyWith({
    bool? isPasswordVisible,
  }) {
    return SignUpFormState(
      formKey: formKey,
      emailController: emailController,
      usernameController: usernameController,
      passwordController: passwordController,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}

class SignUpFormNotifier extends StateNotifier<SignUpFormState> {
  SignUpFormNotifier(this._ref)
    : super(
        SignUpFormState(
          formKey: GlobalKey<FormState>(),
          emailController: TextEditingController(),
          usernameController: TextEditingController(),
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

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void submitSignUp() {
    if (state.formKey.currentState?.validate() != true) {
      return;
    }

    final email = state.emailController.text.trim();
    final username = state.usernameController.text.trim();
    final password = state.passwordController.text.trim();

    _ref
        .read(authenticationControllerProvider.notifier)
        .signUp(
          email: email,
          username: username,
          password: password,
        );
  }

  @override
  void dispose() {
    state.emailController.dispose();
    state.usernameController.dispose();
    state.passwordController.dispose();
    super.dispose();
  }
}

final AutoDisposeStateNotifierProvider<SignUpFormNotifier, SignUpFormState>
signUpFormNotifierProvider =
    StateNotifierProvider.autoDispose<SignUpFormNotifier, SignUpFormState>(
      SignUpFormNotifier.new,
    );
