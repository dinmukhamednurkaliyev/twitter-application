import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Twitter';
    return ProviderScope(
      child: MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        home: SignUpScreen(),
      ),
    );
  }
}
