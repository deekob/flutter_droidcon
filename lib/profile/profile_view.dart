import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_droidcon/data_repository.dart';
import 'package:flutter_droidcon/profile/profile_bloc.dart';
import 'package:flutter_droidcon/profile/profile_event.dart';
import 'package:flutter_droidcon/profile/profile_state.dart';
import 'package:flutter_droidcon/session/session_cubit.dart';
import 'package:flutter_droidcon/storage_repository.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
    return BlocProvider(
      create: (context) => ProfileBloc(
          user: sessionCubit.selectedUser ?? sessionCubit.currentUser,
          isCurrentUser: sessionCubit.isCurrentUserSelected,
          dataRepository: context.read<DataRepository>(),
          storageRepository: context.read<StorageRepository>()),
      child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.isImageSourceActionSheetVisible) {
              _showImageSourceActionSheet(context);
            }
          },
          child: Scaffold(
            appBar: _appBar(),
            body: _profilePage(),
          )),
    );
  }

  PreferredSizeWidget _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        return AppBar(
          title: Text('Profile'),
          actions: [
            if (state.isCurrentUser)
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {},
              ),
          ],
        );
      }),
    );
  }

  Widget _profilePage() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              _avatar(),
              if (state.isCurrentUser) _changeAvatarButton(),
              SizedBox(height: 20),
              _usernameTile(),
              _emailTile(),
              _descriptionTile(),
              if (state.isCurrentUser) _saveProfileChangesButton(),
            ],
          ),
        ),
      );
    });
  }

  Widget _avatar() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state.avatarPath.isEmpty) {
        return CircleAvatar(
          radius: 50,
          child: Icon(Icons.person),
        );
      } else {
        return CircleAvatar(
          radius: 50,
          child: Icon(Icons.person),
          backgroundImage: NetworkImage(state.avatarPath),
        );
      }
    });
  }

  Widget _changeAvatarButton() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return TextButton(
        onPressed: () => context.read<ProfileBloc>().add(ChangeAvatarRequest()),
        child: Text('Change Avatar'),
      );
    });
  }

  Widget _usernameTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.green,
        leading: Icon(Icons.person),
        title: Text(state.username),
      );
    });
  }

  Widget _emailTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.green,
        leading: Icon(Icons.mail),
        title: Text(state.email!.trim()),
      );
    });
  }

  Widget _descriptionTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.green,
        leading: Icon(Icons.edit),
        title: TextFormField(
          initialValue: state.userDescription,
          decoration: InputDecoration.collapsed(
              hintText: state.isCurrentUser
                  ? 'Say something about yourself'
                  : 'This user hasn\'t updated their profile'),
          maxLines: null,
          readOnly: !state.isCurrentUser,
          toolbarOptions: ToolbarOptions(
            copy: state.isCurrentUser,
            cut: state.isCurrentUser,
            paste: state.isCurrentUser,
            selectAll: state.isCurrentUser,
          ),
          onChanged: (value) => context
              .read<ProfileBloc>()
              .add(ProfileDescriptionChanged(description: value)),
        ),
      );
    });
  }

  Widget _saveProfileChangesButton() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ElevatedButton(
        onPressed: () {},
        child: Text('Save Changes'),
      );
    });
  }

  void _showImageSourceActionSheet(BuildContext context) {
    Function(ImageSource) selectImageSource = (imageSource) {
      context
          .read<ProfileBloc>()
          .add(OpenImagePicker(imageSource: imageSource));
    };

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text('Camera'),
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Gallery'),
              onPressed: () {
                try {
                  Navigator.pop(context);
                  selectImageSource(ImageSource.gallery);
                } catch (e) {
                  throw e;
                }
              },
            )
          ],
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.gallery);
            },
          ),
        ]),
      );
    }
  }
}
