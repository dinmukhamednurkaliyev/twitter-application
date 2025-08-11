import 'package:dio/dio.dart';
import 'package:twitter_application/core/core.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

abstract class AuthenticationDataSource {
  Future<UserModel> signUp(SignUpParams params);
  Future<UserModel> signIn(SignInParams params);
}

class AuthenticationDataSourceImpl implements AuthenticationDataSource {
  AuthenticationDataSourceImpl({required this.dio});
  final Dio dio;

  @override
  Future<UserModel> signUp(SignUpParams params) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/signup',
        data: params.toJson(),
      );

      return UserModel.fromJson(
        response.data!,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw const ServerException('A user with this email already exists.');
      }
      throw ServerException('API Error: ${e.message}');
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<UserModel> signIn(SignInParams params) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: params.toJson(),
      );

      return UserModel.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const InvalidCredentialsException('Invalid email or password.');
      }
      throw ServerException('API Error: ${e.message}');
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}
