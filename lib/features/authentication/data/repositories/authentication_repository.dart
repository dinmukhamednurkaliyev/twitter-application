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
  Future<Either<Failure, UserEntity>> signIn({
    required SignInParams params,
  }) async {
    final remoteResult = await remoteDataSource.signIn(params);

    return remoteResult.fold(
      (failure) {
        return Left(failure);
      },

      (authenticationResponse) async {
        final localResult = await localDataSource.saveAuthenticationToken(
          authenticationResponse.token,
        );
        return localResult.fold(
          Left.new,
          (_) => Right(
            authenticationResponse.user,
          ),
        );
      },
    );
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required SignUpParams params,
  }) async {
    final remoteResult = await remoteDataSource.signUp(params);

    return remoteResult.fold(
      Left.new,
      (authenticationResponse) async {
        final localResult = await localDataSource.saveAuthenticationToken(
          authenticationResponse.token,
        );
        return localResult.fold(
          Left.new,
          (_) => Right(authenticationResponse.user),
        );
      },
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return localDataSource.clearAuthenticationToken();
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    final tokenResult = await localDataSource.getAuthenticationToken();

    return tokenResult.fold(
      Left.new,
      (token) async {
        if (token == null) {
          return const Right(null);
        }

        final profileResult = await remoteDataSource.fetchProfile();

        return profileResult.fold(
          (failure) async {
            if (failure is InvalidCredentialsFailure) {
              await localDataSource.clearAuthenticationToken();
            }
            return Left(failure);
          },
          Right.new,
        );
      },
    );
  }
}
