import 'package:flutter_droidcon/auth/form_submission_status.dart';

class LoginState {
  final String username;
  bool get isUserNameValid => username.length > 3;
  final String password;
  bool get isPasswordValid => password.length > 6;

  final FormSubmissionStatus formStatus;

  LoginState({
    this.username = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String? username,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
        username: username ?? this.username,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus);
  }
}
