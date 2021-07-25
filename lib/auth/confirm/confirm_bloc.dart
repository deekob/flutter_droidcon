import 'package:amplify_flutter/auth/auth_cubit.dart';
import 'package:amplify_flutter/auth/auth_repository.dart';
import 'package:amplify_flutter/auth/form_submission_status.dart';
import 'package:amplify_flutter/auth/confirm/confirm_event.dart';
import 'package:amplify_flutter/auth/confirm/confirm_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmBloc extends Bloc<ConfirmEvent, ConfirmState> {
  final AuthRepository repo;
  final AuthCubit authCubit;

  ConfirmBloc({required this.repo, required this.authCubit})
      : super(ConfirmState());

  @override
  Stream<ConfirmState> mapEventToState(ConfirmEvent event) async* {
    if (event is ConfirmCodeChanged) {
      // updating Username
      yield state.copyWith(code: event.code);
    } else if (event is ConfirmSubmitted) {
      //submitting form
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        final userId = await repo.confirm(
            username: authCubit.credentials!.username, code: state.code);
        yield state.copyWith(formStatus: SubmissionSuccess());

        final creds = authCubit.credentials;
        creds!.userId = userId;

        authCubit.launchSession(creds);
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      } catch (e) {
        print(e);
      }
    }
  }
}
