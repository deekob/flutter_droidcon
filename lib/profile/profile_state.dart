import 'package:flutter_droidcon/auth/form_submission_status.dart';
import 'package:flutter_droidcon/models/UserProfile.dart';

class ProfileState {
  final UserProfile? user;
  final bool isCurrentUser;
  final String? avatarPath;
  final String? userDescription;

  String get username => user!.userName;
  String? get email => user!.email;

  final FormSubmissionStatus formStatus;

  ProfileState({
    UserProfile? user,
    required bool isCurrentUser,
    String? avatarPath,
    String? userDescription,
    this.formStatus = const InitialFormStatus(),
  })  : this.user = user,
        this.isCurrentUser = isCurrentUser,
        this.avatarPath = avatarPath,
        this.userDescription = userDescription ?? user!.description;

  ProfileState copyWith({
    UserProfile? user,
    String? avatarPath,
    String? userDescription,
    FormSubmissionStatus? formStatus,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isCurrentUser: this.isCurrentUser,
      avatarPath: avatarPath ?? this.avatarPath,
      userDescription: userDescription ?? this.userDescription,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
