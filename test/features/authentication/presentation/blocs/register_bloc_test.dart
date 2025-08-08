import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:twitter_application/features/authentication/authentication.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  group('RegisterBloc', () {
    late RegisterBloc registerBloc;
    late MockRegisterUseCase mockRegisterUseCase;

    const tEmail = 'test@example.com';
    const tUsername = 'testuser';
    const tPassword = 'strongPassword123';
    const tRegisterEvent = RegisterSubmitted(
      email: tEmail,
      username: tUsername,
      password: tPassword,
    );
    setUp(() {
      mockRegisterUseCase = MockRegisterUseCase();
      registerBloc = RegisterBloc(registerUseCase: mockRegisterUseCase);
    });

    tearDown(() {
      registerBloc.close();
    });

    test('initial state is RegisterInitial', () {
      expect(registerBloc.state, const RegisterInitial());
    });

    group('on RegisterSubmitted', () {
      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterLoading, RegisterLoadingSuccess] when registration is successful',
        setUp: () {
          when(
            () => mockRegisterUseCase(
              email: tEmail,
              username: tUsername,
              password: tPassword,
            ),
          ).thenAnswer((_) async => 'success');
        },
        build: () => registerBloc,
        act: (bloc) => bloc.add(tRegisterEvent),
        expect: () => <RegisterState>[
          const RegisterLoading(),
          const RegisterLoadingSuccess(),
        ],
        verify: (_) {
          verify(
            () => mockRegisterUseCase(
              email: tEmail,
              username: tUsername,
              password: tPassword,
            ),
          ).called(1);
        },
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterLoading, RegisterLoadingFailure] when registration fails',
        setUp: () {
          when(
            () => mockRegisterUseCase(
              email: any(
                named: 'email',
              ),
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Email already in use'));
        },
        build: () => registerBloc,
        act: (bloc) => bloc.add(tRegisterEvent),
        expect: () => <RegisterState>[
          const RegisterLoading(),
          const RegisterLoadingFailure(
            message: 'Exception: Email already in use',
          ),
        ],
        verify: (_) {
          verify(
            () => mockRegisterUseCase(
              email: tEmail,
              username: tUsername,
              password: tPassword,
            ),
          ).called(1);
        },
      );
    });
  });
}
