// Импортируем наши новые типы
import 'package:twitter_application/core/core.dart'; // Either и Failure
import 'package:twitter_application/features/authentication/authentication.dart';

class GetCurrentUserUseCase {
  GetCurrentUserUseCase({required this.repository});
  final AuthenticationRepository repository;

  Future<Either<Failure, UserEntity?>> call() {
    return repository.getCurrentUser();
  }
}
