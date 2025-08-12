import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

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
            SnackBar(content: Text('Sign in Failed: ${next.error}')),
          );
      }
      if (next.hasValue && next.value != null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Welcome back, ${next.value!.username}!'),
            ),
          );
      }
    });

    final formKey = ref.watch(signInFormNotifierProvider).formKey;

    final formWidgets = <Widget>[
      const _EmailInputField(),
      const _PasswordInputField(),
      const Padding(
        padding: EdgeInsets.only(top: 16),
        child: _SignUpLink(),
      ),
      _SignInButton(
        onPressed: () =>
            ref.read(signInFormNotifierProvider.notifier).submitSignIn(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Form(
        key: formKey,
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
    final isLoading = ref.watch(
      authenticationControllerProvider.select((state) => state.isLoading),
    );
    final emailController = ref
        .watch(signInFormNotifierProvider)
        .emailController;

    return TextFormField(
      controller: emailController,
      enabled: !isLoading,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: SignInFormNotifier.validateEmail,
    );
  }
}

class _PasswordInputField extends ConsumerWidget {
  const _PasswordInputField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      authenticationControllerProvider.select((state) => state.isLoading),
    );

    final formState = ref.watch(signInFormNotifierProvider);
    final notifier = ref.read(signInFormNotifierProvider.notifier);

    return TextFormField(
      controller: formState.passwordController,
      enabled: !isLoading,
      obscureText: !formState.isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            formState.isPasswordVisible
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: notifier.togglePasswordVisibility,
        ),
      ),
      validator: SignInFormNotifier.validatePassword,
    );
  }
}

class _SignUpLink extends StatelessWidget {
  const _SignUpLink();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: theme.textTheme.bodyMedium,
        children: [
          const TextSpan(text: "Don't have an account? "),
          TextSpan(
            text: 'Sign Up',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ],
      ),
    );
  }
}

class _SignInButton extends ConsumerWidget {
  const _SignInButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      authenticationControllerProvider.select((state) => state.isLoading),
    );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const RepaintBoundary(
              child: SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            )
          : const Text('Sign In'),
    );
  }
}
