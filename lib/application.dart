import 'package:flutter/material.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return const ApplicationView();
  }
}

class ApplicationView extends StatelessWidget {
  const ApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Twitter',
      debugShowCheckedModeBanner: false,
      home: AuthenticationPage(),
    );
  }
}
