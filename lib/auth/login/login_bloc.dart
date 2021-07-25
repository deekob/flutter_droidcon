import 'package:amplify_flutter/auth/auth_credentials.dart';
import 'package:amplify_flutter/auth/auth_cubit.dart';
import 'package:amplify_flutter/auth/auth_repository.dart';
import 'package:amplify_flutter/auth/form_submission_status.dart';
import 'package:amplify_flutter/auth/login/login_event.dart';
import 'package:amplify_flutter/auth/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repo;
  final AuthCubit authCubit;

  LoginBloc({required this.repo, required this.authCubit})
      : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is UserNameChanged) {
      // updating Username
      yield state.copyWith(username: event.username);
    } else if (event is PasswordChanged) {
      // updating password
      yield state.copyWith(password: event.password);
    } else if (event is LoginSubmitted) {
      //submitting form
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        // call login
        final userId = await repo.login(
            username: state.username, password: state.password);

        yield state.copyWith(formStatus: SubmissionSuccess());

        authCubit.launchSession(
            AuthCredentials(username: state.username, userId: userId));
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      } catch (e) {
        print(e);
      }
    }
  }
}
