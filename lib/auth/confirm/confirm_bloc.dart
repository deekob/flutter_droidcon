import 'package:flutter_droidcon/auth/auth_cubit.dart';
import 'package:flutter_droidcon/auth/auth_repository.dart';
import 'package:flutter_droidcon/auth/form_submission_status.dart';
import 'package:flutter_droidcon/auth/confirm/confirm_event.dart';
import 'package:flutter_droidcon/auth/confirm/confirm_state.dart';
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
      final credentials = authCubit.credentials;

      try {
        await repo.confirm(username: credentials.username, code: state.code);
        yield state.copyWith(formStatus: SubmissionSuccess());

        final userId = await repo.login(
            username: credentials.username, password: credentials.pasword);

        credentials.userId = userId;

        authCubit.launchSession(credentials);
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      } catch (e) {
        print(e);
      }
    }
  }
}
