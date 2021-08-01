import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_droidcon/models/UserProfile.dart';
import 'package:flutter_droidcon/profile/profile_event.dart';
import 'package:flutter_droidcon/profile/profile_state.dart';
import 'package:image_picker/image_picker.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _imagePicker = ImagePicker();
  ProfileBloc({UserProfile? user, required bool isCurrentUser})
      : super(ProfileState(user: user, isCurrentUser: isCurrentUser));

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ChangeAvatarRequest) {
      yield state.copyWith(isImageSourceActionSheetVisible: true);
    } else if (event is OpenImagePicker) {
      yield state.copyWith(isImageSourceActionSheetVisible: false);
      final selectedImage =
          await _imagePicker.pickImage(source: event.imageSource);
      if (selectedImage != null)
        yield state.copyWith(avatarPath: selectedImage.path);
    } else if (event is ProvideImagePath) {
      yield state.copyWith(avatarPath: event.avatarPath);
    } else if (event is ProfileDescriptionChanged) {
      yield state.copyWith(userDescription: event.description);
    } else if (event is SaveProfileChanges) {
      // handle save changes
    }
  }
}
