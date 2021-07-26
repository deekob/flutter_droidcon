import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_droidcon/models/UserProfile.dart';
import 'package:flutter_droidcon/profile/profile_event.dart';
import 'package:flutter_droidcon/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({UserProfile? user, required bool isCurrentUser})
      : super(ProfileState(user: user, isCurrentUser: isCurrentUser));

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ChangeAvatarRequest) {
      // show action sheet
    } else if (event is OpenImagePicker) {
      // open image picker
    } else if (event is ProvideImagePath) {
      yield state.copyWith(avatarPath: event.avatarPath);
    } else if (event is ProfileDescriptionChanged) {
      yield state.copyWith(userDescription: event.description);
    } else if (event is SaveProfileChanges) {
      // handle save changes
    }
  }
}
