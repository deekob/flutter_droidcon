import 'package:flutter_droidcon/auth/form_submission_status.dart';
import 'package:flutter_droidcon/models/UserProfile.dart';

class ProfileState {
  final UserProfile? user;
  final bool isCurrentUser;
  String avatarPath = '';
  final String? userDescription;

  String get username => user!.userName;
  String? get email => user!.email;

  final FormSubmissionStatus formStatus;
  bool isImageSourceActionSheetVisible = false;

  ProfileState({
    UserProfile? user,
    required bool isCurrentUser,
    String? avatarPath,
    String? userDescription,
    this.formStatus = const InitialFormStatus(),
    bool isImageSourceActionSheetVisible = false,
  })  : this.user = user,
        this.isCurrentUser = isCurrentUser,
        this.avatarPath = avatarPath ?? '',
        this.userDescription = userDescription ?? user!.description,
        this.isImageSourceActionSheetVisible = isImageSourceActionSheetVisible;

  ProfileState copyWith({
    UserProfile? user,
    String? avatarPath,
    String? userDescription,
    FormSubmissionStatus? formStatus,
    bool? isImageSourceActionSheetVisible,
  }) {
    return ProfileState(
        user: user ?? this.user,
        isCurrentUser: this.isCurrentUser,
        avatarPath: avatarPath ?? this.avatarPath,
        userDescription: userDescription ?? this.userDescription,
        formStatus: formStatus ?? this.formStatus,
        isImageSourceActionSheetVisible: isImageSourceActionSheetVisible ??
            this.isImageSourceActionSheetVisible);
  }
}
