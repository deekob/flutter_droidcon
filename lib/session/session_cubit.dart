import 'package:amplify_api/amplify_api.dart';
import 'package:flutter_droidcon/auth/auth_credentials.dart';
import 'package:flutter_droidcon/auth/auth_repository.dart';
import 'package:flutter_droidcon/data_repository.dart';
import 'package:flutter_droidcon/models/UserProfile.dart';
import 'package:flutter_droidcon/session/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  final DataRepository dataRepo;

  SessionCubit({required this.authRepo, required this.dataRepo})
      : super(UnknownSessionState()) {
    attemptSignIn();
  }

  void attemptSignIn() async {
    try {
      final userId = await authRepo.attemptLogin();
      if (userId == null) {
        throw Exception('User not logged in');
      }
      var user = await dataRepo.getUserById(userId);
      if (user == null) {
        user = await dataRepo.createProfile(
            userId: userId, userName: 'User=${UUID()}');
      }
      emit(Authenticated(user: user));
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(AuthCredentials credentials) async {
    try {
      UserProfile? user = await dataRepo.getUserById(credentials.userId);

      if (user == null) {
        user = await dataRepo.createProfile(
            userName: credentials.username,
            userId: credentials.userId,
            email: credentials.email);
      }
      emit(Authenticated(user: user));
    } catch (e) {}
  }

  void signOut() {
    authRepo.signOut();
    emit(Unauthenticated());
  }
}
