import 'package:amplify_flutter/auth/auth_credentials.dart';
import 'package:amplify_flutter/session/session_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  final SessionCubit sessionCubit;

  AuthCubit({required this.sessionCubit}) : super(AuthState.login);

  AuthCredentials? credentials;

  void showLogin() => emit(AuthState.login);
  void showSignUp() => emit(AuthState.signUp);
  void showConfirmSignUp({
    String? username,
    String? email,
    String? password,
  }) {
    credentials =
        AuthCredentials(username: username, email: email, pasword: password);
    emit(AuthState.confirmSignUp);
  }

  void launchSession(AuthCredentials credentials) {
    sessionCubit.showSession(credentials);
  }
}
