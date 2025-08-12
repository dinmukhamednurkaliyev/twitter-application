import 'package:twitter_application/core/core.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  AuthenticationRepositoryImplementation({required this.remoteDataSource});
  final AuthenticationDataSource remoteDataSource;

  @override
  Future<UserEntity> signUp({required SignUpParams params}) async {
    try {
      final userModel = await remoteDataSource.signUp(params);
      return userModel;
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } on NetworkException catch (e) {
      throw NetworkException(e.message);
    } catch (e) {
      throw ServerException('An unexpectged error occurred: $e');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> signIn({required SignInParams params}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
