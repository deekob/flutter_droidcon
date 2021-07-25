import 'package:amplify_flutter/auth/auth_credentials.dart';
import 'package:amplify_flutter/auth/auth_repository.dart';
import 'package:amplify_flutter/session/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;

  SessionCubit({required this.authRepo}) : super(UnknownSessionState()) {
    attemptSignIn();
  }

  void attemptSignIn() async {
    try {
      final userId = await authRepo.attemptLogin();
      //   final user = dataRepo.getByUserId();
      final user = userId;
      emit(Authenticated(user: user));
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(AuthCredentials credentials) {
    //final user = daraRepo.getUser(credentials.userId);
    final user = credentials.username;

    emit(Authenticated(user: user));
  }

  void signOut() {
    authRepo.signOut();
    emit(Unauthenticated());
  }
}
