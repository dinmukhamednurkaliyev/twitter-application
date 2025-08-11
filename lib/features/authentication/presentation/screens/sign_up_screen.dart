import 'package:flutter/gestures.dart';
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
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  void _onRegisterSubmitted(WidgetRef ref) {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final email = ref.read(_emailControllerProvider).text.trim();
    final username = ref.read(_usernameControllerProvider).text.trim();
    final password = ref.read(_passwordControllerProvider).text.trim();

    ref
        .read(authenticationControllerProvider.notifier)
        .signUp(
          email: email,
          username: username,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<UserEntity?>>(authenticationControllerProvider, (
      previous,
      next,
    ) {
      final messenger = ScaffoldMessenger.of(context);
      if (next.hasError && !next.isLoading) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('Sign up Failed: ${next.error}')),
          );
      }
      if (next.hasValue && next.value != null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Welcome, ${next.value!.username}! Sign up successful.',
              ),
            ),
          );
      }
    });

    final formWidgets = <Widget>[
      const _EmailInputField(),
      const _UsernameInputField(),
      const _PasswordInputField(),
      const Padding(
        padding: EdgeInsets.only(
          top: 16,
        ),
        child: _SignInLink(),
      ),
      _SignUpButton(onPressed: () => _onRegisterSubmitted(ref)),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.separated(
            itemCount: formWidgets.length,
            itemBuilder: (context, index) => formWidgets[index],
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
        ),
      ),
    );
  }
}

class _EmailInputField extends ConsumerWidget {
  const _EmailInputField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticationState = ref.watch(authenticationControllerProvider);
    final emailController = ref.watch(_emailControllerProvider);

    return TextFormField(
      controller: emailController,
      enabled: !authenticationState.isLoading,
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
  const _UsernameInputField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticationState = ref.watch(authenticationControllerProvider);
    final usernameController = ref.watch(_usernameControllerProvider);

    return TextFormField(
      controller: usernameController,
      enabled: !authenticationState.isLoading,
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
  const _PasswordInputField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticationState = ref.watch(authenticationControllerProvider);
    final passwordController = ref.watch(_passwordControllerProvider);

    return TextFormField(
      controller: passwordController,
      enabled: !authenticationState.isLoading,
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

class _SignInLink extends StatelessWidget {
  const _SignInLink();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: theme.textTheme.bodyMedium,
        children: [
          const TextSpan(text: 'Already have an account? '),
          TextSpan(
            text: 'Sign In',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                print('Navigate to Sign In screen');
              },
          ),
        ],
      ),
    );
  }
}

class _SignUpButton extends ConsumerWidget {
  const _SignUpButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authenticationControllerProvider);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      onPressed: authState.isLoading ? null : onPressed,
      child: authState.isLoading
          ? const RepaintBoundary(
              child: SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            )
          : const Text('Sign Up'),
    );
  }
}
