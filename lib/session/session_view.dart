import 'package:flutter_droidcon/models/UserProfile.dart';
import 'package:flutter_droidcon/session/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionView extends StatelessWidget {
  final UserProfile? userProfile;

  SessionView({Key? key, this.userProfile}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    final username = userProfile!.userName;
    final email = userProfile!.email;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello $username'),
            Text('Email: $email'),
            TextButton(
                onPressed: () =>
                    BlocProvider.of<SessionCubit>(context).signOut(),
                child: Text('Sign Out'))
          ],
        ),
      ),
    );
  }
}
