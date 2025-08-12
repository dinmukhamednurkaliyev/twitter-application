import 'package:dio/dio.dart';
import 'package:twitter_application/core/core.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

abstract class AuthenticationRemoteDataSource {
  Future<Either<Failure, AuthenticationResponseModel>> signUp(
    SignUpParams params,
  );
  Future<Either<Failure, AuthenticationResponseModel>> signIn(
    SignInParams params,
  );

  Future<Either<Failure, UserModel>> fetchProfile();
}

class AuthenticationRemoteDataSourceImplementation
    implements AuthenticationRemoteDataSource {
  AuthenticationRemoteDataSourceImplementation({required this.dio});
  final Dio dio;

  @override
  Future<Either<Failure, AuthenticationResponseModel>> signUp(
    SignUpParams params,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/signup',
        data: params.toJson(),
      );
      return Right(AuthenticationResponseModel.fromJson(response.data!));
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return const Left(
          ServerFailure(
            message: 'A user with this email already exists.',
          ),
        );
      }
      return Left(ServerFailure(message: 'API Error: ${e.message}'));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthenticationResponseModel>> signIn(
    SignInParams params,
  ) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: params.toJson(),
      );
      return Right(AuthenticationResponseModel.fromJson(response.data!));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(
          InvalidCredentialsFailure(
            message: 'Invalid email or password.',
          ),
        );
      }
      return Left(ServerFailure(message: 'API Error: ${e.message}'));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> fetchProfile() async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/auth/me',
      );

      return Right(UserModel.fromJson(response.data!));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(
          InvalidCredentialsFailure(
            message: 'Token is invalid or expired.',
          ),
        );
      }
      return Left(
        ServerFailure(message: 'Failed to fetch profile: ${e.message}'),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }
}
