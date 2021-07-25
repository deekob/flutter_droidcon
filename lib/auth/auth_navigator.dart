import 'package:amplify_flutter/auth/auth_cubit.dart';
import 'package:amplify_flutter/auth/confirm/confirm_view.dart';
import 'package:amplify_flutter/auth/login/login_view.dart';
import 'package:amplify_flutter/auth/signup/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return Navigator(
        pages: [
          if (state == AuthState.login) MaterialPage(child: LoginView()),
          // Push Confirm
          if (state == AuthState.signUp ||
              state == AuthState.confirmSignUp) ...[
            //always show signup
            MaterialPage(child: SignUpView()),

            if (state == AuthState.confirmSignUp)
              MaterialPage(child: ConfirmView())
          ]
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
