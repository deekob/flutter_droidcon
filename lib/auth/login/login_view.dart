import 'package:amplify_flutter/auth/auth_cubit.dart';
import 'package:amplify_flutter/auth/auth_repository.dart';
import 'package:amplify_flutter/auth/form_submission_status.dart';
import 'package:amplify_flutter/auth/login/login_event.dart';
import 'package:amplify_flutter/auth/login/login_state.dart';
import 'package:amplify_flutter/auth/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(
          repo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: Stack(
            alignment: Alignment.bottomCenter,
            children: [_loginForm(), _signUpButton(context)]),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailed) {
          _showSnackBar(context, formStatus.exception.toString());
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_usernameField(), _passwordField(), _loginButton()],
          ),
        ),
      ),
    );
  }

  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
          decoration: InputDecoration(
              icon: Icon(Icons.person), hintText: 'Enter User Name'),
          validator: (value) =>
              state.isUserNameValid ? null : "User Name not long enough",
          onChanged: (value) => context.read<LoginBloc>().add(
                UserNameChanged(username: value),
              ));
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: InputDecoration(
            icon: Icon(Icons.security), hintText: 'Enter Password'),
        validator: (value) =>
            state.isPasswordValid ? null : "Password not long enough",
        onChanged: (value) =>
            context.read<LoginBloc>().add(PasswordChanged(password: value)),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              },
              child: Text('Login'));
    });
  }

  Widget _signUpButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
        child: Text('Dont have an account ? - Please Sign Up'),
        onPressed: () => context.read<AuthCubit>().showSignUp(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
