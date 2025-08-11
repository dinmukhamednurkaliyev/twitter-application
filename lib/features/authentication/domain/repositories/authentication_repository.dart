import 'package:twitter_application/features/authentication/authentication.dart';

abstract class AuthenticationRepository {
  Future<UserEntity> signUp({required SignUpParams params});
  Future<UserEntity> signIn({required SignInParams params});
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
}
