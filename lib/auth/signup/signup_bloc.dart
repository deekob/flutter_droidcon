import 'package:amplify_flutter/auth/auth_cubit.dart';
import 'package:amplify_flutter/auth/auth_repository.dart';
import 'package:amplify_flutter/auth/form_submission_status.dart';
import 'package:amplify_flutter/auth/signup/signup_event.dart';
import 'package:amplify_flutter/auth/signup/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository repo;
  final AuthCubit authCubit;

  SignUpBloc({required this.repo, required this.authCubit})
      : super(SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is UserNameChanged) {
      // updating Username
      yield state.copyWith(username: event.username);
    } else if (event is EmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is PasswordChanged) {
      // updating password
      yield state.copyWith(password: event.password);
    } else if (event is SignUpSubmitted) {
      //submitting form
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        await repo.signUp(
            username: state.username,
            email: state.email,
            password: state.password);
        yield state.copyWith(formStatus: SubmissionSuccess());

        authCubit.showConfirmSignUp(
            username: state.username,
            email: state.email,
            password: state.password);
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      } catch (e) {
        print(e);
      }
    }
  }
}
