import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  group('RegisterUseCase', () {
    late RegisterUseCase useCase;
    late MockAuthenticationRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthenticationRepository();
      useCase = RegisterUseCase(authenticationRepository: mockRepository);
    });

    const tEmail = 'test@mail.com';
    const tUsername = 'testuser';
    const tPassword = 'password123';
    const tToken = '_super_secret_auth_token_';

    const tUserEntity = UserEntity(
      email: tEmail,
      username: tUsername,
      password: tPassword,
    );

    test(
      'should call authenticationRepository.register and return token successfully',
      () async {
        when(
          () => mockRepository.register(user: tUserEntity),
        ).thenAnswer((_) async => tToken);

        final result = await useCase(
          email: tEmail,
          username: tUsername,
          password: tPassword,
        );

        expect(result, tToken);
        verify(() => mockRepository.register(user: tUserEntity)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should throw an exception when repository throws an exception',
      () async {
        final tException = Exception('Email already exists');
        when(
          () => mockRepository.register(user: any(named: 'user')),
        ).thenThrow(tException);

        final call = useCase.call;

        expect(
          () => call(email: tEmail, username: tUsername, password: tPassword),
          throwsA(isA<Exception>()),
        );

        verify(() => mockRepository.register(user: tUserEntity)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
