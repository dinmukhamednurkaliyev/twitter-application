import 'package:twitter_application/core/core.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, UserEntity>> signUp({required SignUpParams params});
  Future<Either<Failure, UserEntity>> signIn({required SignInParams params});

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
