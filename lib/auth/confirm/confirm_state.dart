import 'package:amplify_flutter/auth/form_submission_status.dart';

class ConfirmState {
  final String code;
  bool get isUserNameValid => code.length > 3;

  final FormSubmissionStatus formStatus;

  ConfirmState({
    this.code = '',
    this.formStatus = const InitialFormStatus(),
  });

  ConfirmState copyWith({
    String? code,
    FormSubmissionStatus? formStatus,
  }) {
    return ConfirmState(
        code: code ?? this.code, formStatus: formStatus ?? this.formStatus);
  }
}
