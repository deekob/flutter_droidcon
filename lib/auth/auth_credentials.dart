import 'package:flutter/foundation.dart';

class AuthCredentials {
  final String? username;
  final String? pasword;
  final String? email;
  String? userId;

  AuthCredentials({
    @required this.username,
    this.email,
    this.pasword,
    this.userId,
  });
}
