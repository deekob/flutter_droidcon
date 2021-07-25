class AuthRepository {
  Future<String> attemptLogin() async {
    await Future.delayed(Duration(seconds: 2));
    throw Exception('Not Logged in');
  }

  Future<String> login({String? username, String? password}) async {
    print("trying to login");
    await Future.delayed(Duration(seconds: 5));
    return 'abc';
  }

  Future<void> signUp(
      {String? username, String? email, String? password}) async {
    await Future.delayed(Duration(seconds: 5));
  }

  Future<String> confirm({String? username, String? code}) async {
    await Future.delayed(Duration(seconds: 5));
    return 'abc';
  }

  Future<void> signOut() async {
    await Future.delayed(Duration(seconds: 5));
  }
}
