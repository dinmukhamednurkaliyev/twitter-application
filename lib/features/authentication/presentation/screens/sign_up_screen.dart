import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

final AutoDisposeProvider<TextEditingController> _emailControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());
final AutoDisposeProvider<TextEditingController> _usernameControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());
final AutoDisposeProvider<TextEditingController> _passwordControllerProvider =
    Provider.autoDispose((ref) => TextEditingController());

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<String?>>(signUpControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Sign up Failed: $error')),
            );
        },
        data: (token) {
          if (token != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Sign up Successful!')),
              );
          }
        },
      );
    });

    final emailController = ref.read(_emailControllerProvider);
    final usernameController = ref.read(_usernameControllerProvider);
    final passwordController = ref.read(_passwordControllerProvider);

    void onRegisterSubmitted() {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      ref
          .read(signUpControllerProvider.notifier)
          .signUp(
            email: emailController.text.trim(),
            username: usernameController.text.trim(),
            password: passwordController.text.trim(),
          );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _EmailInputField(),
              const SizedBox(height: 16),
              _UsernameInputField(),
              const SizedBox(height: 16),
              _PasswordInputField(),
              const SizedBox(height: 32),
              _SignUpButton(onPressed: onRegisterSubmitted),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInputField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpControllerProvider);
    final isLoading = signUpState.isLoading;
    final emailController = ref.watch(_emailControllerProvider);

    return TextFormField(
      controller: emailController,
      enabled: !isLoading,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Email is required';
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}

class _UsernameInputField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpControllerProvider);
    final isLoading = signUpState.isLoading;
    final usernameController = ref.watch(_usernameControllerProvider);

    return TextFormField(
      controller: usernameController,
      enabled: !isLoading,
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Username is required';
        }
        return null;
      },
    );
  }
}

class _PasswordInputField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpControllerProvider);
    final isLoading = signUpState.isLoading;
    final passwordController = ref.watch(_passwordControllerProvider);

    return TextFormField(
      controller: passwordController,
      enabled: !isLoading,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
    );
  }
}

class _SignUpButton extends ConsumerWidget {
  const _SignUpButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpControllerProvider);
    final isLoading = signUpState.isLoading;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : const Text('Sign Up'),
    );
  }
}
