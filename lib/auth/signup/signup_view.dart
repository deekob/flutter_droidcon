import 'package:amplify_flutter/auth/auth_cubit.dart';
import 'package:amplify_flutter/auth/auth_repository.dart';
import 'package:amplify_flutter/auth/form_submission_status.dart';
import 'package:amplify_flutter/auth/signup/signup_event.dart';
import 'package:amplify_flutter/auth/signup/signup_state.dart';
import 'package:amplify_flutter/auth/signup/signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignUpBloc(
          repo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: Stack(
            alignment: Alignment.bottomCenter,
            children: [_signUpForm(), _loginButton(context)]),
      ),
    );
  }

  Widget _signUpForm() {
    return BlocListener<SignUpBloc, SignUpState>(
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
            children: [
              _usernameField(),
              _emailField(),
              _passwordField(),
              _signupButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _usernameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
          decoration: InputDecoration(
              icon: Icon(Icons.person), hintText: 'Enter User Name'),
          validator: (value) =>
              state.isUserNameValid ? null : "User Name not long enough",
          onChanged: (value) => context.read<SignUpBloc>().add(
                UserNameChanged(username: value),
              ));
    });
  }

  Widget _emailField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
          decoration: InputDecoration(
              icon: Icon(Icons.email), hintText: 'Enter Email Address'),
          validator: (value) => state.isEmailValid ? null : "Not a valid email",
          onChanged: (value) => context.read<SignUpBloc>().add(
                EmailChanged(email: value),
              ));
    });
  }

  Widget _passwordField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: InputDecoration(
            icon: Icon(Icons.security), hintText: 'Enter Password'),
        validator: (value) =>
            state.isPasswordValid ? null : "Password not long enough",
        onChanged: (value) =>
            context.read<SignUpBloc>().add(PasswordChanged(password: value)),
      );
    });
  }

  Widget _signupButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<SignUpBloc>().add(SignUpSubmitted());
                }
              },
              child: Text('Please Sign Up'));
    });
  }

  Widget _loginButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
        child: Text('Already have an account ? - Please Login'),
        onPressed: () => context.read<AuthCubit>().showLogin(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
