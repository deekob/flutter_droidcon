abstract class SignUpEvent {}

class UserNameChanged extends SignUpEvent {
  final String? username;

  UserNameChanged({this.username});
}

class EmailChanged extends SignUpEvent {
  final String? email;
  EmailChanged({this.email});
}

class PasswordChanged extends SignUpEvent {
  final String? password;

  PasswordChanged({this.password});
}

class SignUpSubmitted extends SignUpEvent {}
