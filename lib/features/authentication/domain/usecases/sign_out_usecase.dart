import 'package:twitter_application/core/core.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class SignOutUseCase {
  const SignOutUseCase({required this.repository});
  final AuthenticationRepository repository;

  Future<Either<Failure, void>> call() {
    return repository.signOut();
  }
}
