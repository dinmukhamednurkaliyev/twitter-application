import 'package:twitter_application/features/authentication/domain/entities/user_entity.dart';
import 'package:twitter_application/features/authentication/domain/repositories/authentication_repository.dart';

class GetCurrentUserUseCase {
  GetCurrentUserUseCase({required this.repository});
  final AuthenticationRepository repository;
  Future<UserEntity?> call() => repository.getCurrentUser();
}
