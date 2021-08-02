import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_droidcon/data_repository.dart';
import 'package:flutter_droidcon/models/UserProfile.dart';
import 'package:flutter_droidcon/profile/profile_event.dart';
import 'package:flutter_droidcon/profile/profile_state.dart';
import 'package:flutter_droidcon/storage_repository.dart';
import 'package:image_picker/image_picker.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final StorageRepository storageRepository;
  final DataRepository dataRepository;
  final _imagePicker = ImagePicker();

  ProfileBloc(
      {required this.storageRepository,
      required this.dataRepository,
      UserProfile? user,
      required bool isCurrentUser})
      : super(ProfileState(user: user, isCurrentUser: isCurrentUser)) {
    storageRepository
        .getUrlForFile(user!.imageKey)
        .then((url) => add(ProvideImagePath(imagePath: url)));
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ChangeAvatarRequest) {
      yield state.copyWith(isImageSourceActionSheetVisible: true);
    } else if (event is OpenImagePicker) {
      yield state.copyWith(isImageSourceActionSheetVisible: false);
      try {
        final selectedImage =
            await _imagePicker.pickImage(source: event.imageSource);
        if (selectedImage == null) return;
        final imageKey =
            await storageRepository.uploadFile(File(selectedImage.path));
        final user = state.user!.copyWith(imageKey: imageKey);

        String? imageUrl;
        await Future.wait<void>([
          dataRepository.updateProfile(user),
          storageRepository
              .getUrlForFile(imageKey)
              .then((value) => imageUrl = value)
        ]);

        yield state.copyWith(avatarPath: imageUrl);
      } catch (e) {
        throw e;
      }
    } else if (event is ProvideImagePath) {
      if (event.imagePath != null)
        yield state.copyWith(avatarPath: event.imagePath);
    } else if (event is ProfileDescriptionChanged) {
      yield state.copyWith(userDescription: event.description);
    } else if (event is SaveProfileChanges) {
      // handle save changes
    }
  }
}
