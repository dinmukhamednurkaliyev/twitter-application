import 'package:twitter_application/core/core.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  AuthenticationRepositoryImplementation({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  final AuthenticationRemoteDataSource remoteDataSource;
  final AuthenticationLocalDataSource localDataSource;

  @override
  Future<UserEntity> signIn({required SignInParams params}) async {
    try {
      final authenticationResponse = await remoteDataSource.signIn(
        params,
      );
      await localDataSource.saveAuthenticationToken(
        authenticationResponse.token,
      );
      return authenticationResponse.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> signUp({required SignUpParams params}) async {
    try {
      final authenticationResponse = await remoteDataSource.signUp(params);
      await localDataSource.saveAuthenticationToken(
        authenticationResponse.token,
      );
      return authenticationResponse.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await localDataSource.clearAuthenticationToken();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final token = await localDataSource.getAuthenticationToken();
      if (token == null) {
        return null;
      }

      final user = await remoteDataSource.fetchProfile();
      return user;
    } on InvalidCredentialsException {
      await localDataSource.clearAuthenticationToken();
      return null;
    } on CacheException {
      return null;
    } on ServerException {
      return null;
    } on Exception {
      return null;
    }
  }
}
