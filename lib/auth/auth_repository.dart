import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

class AuthRepository {
  Future<String?> attemptLogin() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      return session.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } catch (e) {
      throw e;
    }
  }

  Future<String> login({String? username, String? password}) async {
    try {
      final result = await Amplify.Auth.signIn(
          username: username!.trim(), password: password!.trim());

      return result.isSignedIn ? (await _getUserIdFromAttributes()) : '';
    } catch (e) {
      throw e;
    }
  }

  Future<bool> signUp(
      {required String username,
      required String email,
      required String password}) async {
    final options = CognitoSignUpOptions(userAttributes: {
      'email': email.trim(),
      'preferred_username': username
    });
    try {
      final result = await Amplify.Auth.signUp(
          username: username.trim(),
          password: password.trim(),
          options: options);
      return result.isSignUpComplete;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> confirm({String? username, String? code}) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: username!.trim(), confirmationCode: code!.trim());

      return result.isSignUpComplete;
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }

  Future<String> _getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes
          .firstWhere((element) => element.userAttributeKey == 'sub')
          .value;
      return userId;
    } catch (e) {
      throw e;
    }
  }
}
