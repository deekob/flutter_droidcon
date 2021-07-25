abstract class ConfirmEvent {}

class ConfirmCodeChanged extends ConfirmEvent {
  final String? code;

  ConfirmCodeChanged({this.code});
}

class ConfirmSubmitted extends ConfirmEvent {}
