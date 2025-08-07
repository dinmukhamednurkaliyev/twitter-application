class RegisterUseCase {
  const RegisterUseCase();

  Future<String> call({
    required String email,
    required String username,
    required String password,
  }) async {
    return 'token';
  }

}
