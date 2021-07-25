import 'package:amplify_flutter/auth/form_submission_status.dart';

class SignUpState {
  final String username;
  bool get isUserNameValid => username.length > 3;
  final String email;
  bool get isEmailValid => email.contains('@');
  final String password;
  bool get isPasswordValid => password.length > 6;

  final FormSubmissionStatus formStatus;

  SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return SignUpState(
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus);
  }
}
