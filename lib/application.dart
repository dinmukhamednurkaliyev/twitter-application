import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: const [],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SignUpBloc(
              signUpUseCase: const SignUpUseCase(
                authenticationRepository: AuthenticationRepositoryImpl(),
              ),
            ),
          ),
        ],
        child: const ApplicationView(),
      ),
    );
  }
}

class ApplicationView extends StatelessWidget {
  const ApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Twitter';
    return const MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}
