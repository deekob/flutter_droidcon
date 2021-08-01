import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent {}

class ChangeAvatarRequest extends ProfileEvent {}

class OpenImagePicker extends ProfileEvent {
  final ImageSource imageSource;

  OpenImagePicker({required this.imageSource});
}

class ProvideImagePath extends ProfileEvent {
  final String avatarPath;

  ProvideImagePath({required this.avatarPath});
}

class ProfileDescriptionChanged extends ProfileEvent {
  final String description;

  ProfileDescriptionChanged({required this.description});
}

class SaveProfileChanges extends ProfileEvent {}
