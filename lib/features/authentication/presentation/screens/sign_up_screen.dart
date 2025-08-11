import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(
        signUpUseCase: SignUpUseCase(
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
      ),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterSubmitted() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<SignUpBloc>().add(
      SignUpSubmitted(
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: BlocListener<SignUpBloc, SignUp>(
        listener: (context, state) {
          if (state is SignInFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Sign up Failed: ${state.message}'),
                ),
              );
          }
          if (state is SignInSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Sign up Successful!')),
              );
          }
        },
        child: Form(
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
                _RegisterButton(onPressed: _onRegisterSubmitted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<SignUpBloc>().state;
    final viewState = context.read<_SignUpViewState>();

    return TextFormField(
      controller: viewState._emailController,
      enabled: state is! SignUpLoading,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}

class _UsernameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<SignUpBloc>().state;
    final viewState = context.read<_SignUpViewState>();

    return TextFormField(
      controller: viewState._usernameController,
      enabled: state is! SignUpLoading,
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

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<SignUpBloc>().state;
    final viewState = context.read<_SignUpViewState>();

    return TextFormField(
      controller: viewState._passwordController,
      enabled: state is! SignUpLoading,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUp>(
      builder: (context, state) {
        final isLoading = state is SignUpLoading;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text('Register'),
        );
      },
    );
  }
}
