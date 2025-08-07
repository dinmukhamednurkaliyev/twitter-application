import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

void main() {
  group('RegisterUseCase test', () {
    test('Should register user successfully and return token', () async {
      const email = 'fabrice@test.com';
      const username = 'fabrice';
      const password = 'password123';

      const registerUseCase = RegisterUseCase();

      final result = await registerUseCase.call(
        email: email,
        username: username,
        password: password,
      );

      expect(result, 'token');
    });
  });
}
