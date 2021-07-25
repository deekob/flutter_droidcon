import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_droidcon/app_navigator.dart';
import 'package:flutter_droidcon/auth/auth_repository.dart';
import 'package:flutter_droidcon/models/ModelProvider.dart';
import 'package:flutter_droidcon/session/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_droidcon/views/loading_view.dart';

import '/config/amplifyconfiguration.dart';

void main() {
  runApp(FlutterDroidCon());
}

class FlutterDroidCon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<FlutterDroidCon> {
  bool _isAmplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: _isAmplifyConfigured
            ? RepositoryProvider(
                create: (context) => AuthRepository(),
                child: BlocProvider(
                  create: (context) =>
                      SessionCubit(authRepo: context.read<AuthRepository>()),
                  child: AppNavigator(),
                ),
              )
            : LoadingView());
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyDataStore(modelProvider: ModelProvider.instance),
        AmplifyAPI()
      ]);

      await Amplify.configure(amplifyconfig);

      setState(() => _isAmplifyConfigured = true);
    } catch (e) {}
  }
}
