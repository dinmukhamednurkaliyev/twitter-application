import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

final authenticationRepositoryProvider = Provider<AuthenticationRepository>((
  ref,
) {
  return const AuthenticationRepositoryImpl();
});
