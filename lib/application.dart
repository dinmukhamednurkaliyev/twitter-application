import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_application/features/home/home.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: const [],
      child: MultiBlocProvider(
        providers: const [],
        child: const ApplicationView(),
      ),
    );
  }
}

class ApplicationView extends StatelessWidget {
  const ApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Twitter',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
