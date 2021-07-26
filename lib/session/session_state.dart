import 'package:flutter_droidcon/models/UserProfile.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class Unauthenticated extends SessionState {}

class Authenticated extends SessionState {
  final UserProfile? user;

  Authenticated({this.user});
}
