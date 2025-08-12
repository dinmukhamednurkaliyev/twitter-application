import 'package:twitter_application/features/authentication/domain/repositories/authentication_repository.dart';

class SignOutUseCase {
  SignOutUseCase({required this.repository});
  final AuthenticationRepository repository;
  Future<void> call() => repository.signOut();
}
