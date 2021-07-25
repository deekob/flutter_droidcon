import 'package:flutter_droidcon/auth/auth_cubit.dart';
import 'package:flutter_droidcon/auth/auth_repository.dart';
import 'package:flutter_droidcon/auth/confirm/confirm_bloc.dart';
import 'package:flutter_droidcon/auth/form_submission_status.dart';
import 'package:flutter_droidcon/auth/confirm/confirm_event.dart';
import 'package:flutter_droidcon/auth/confirm/confirm_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ConfirmBloc(
          repo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: _confirmForm(),
      ),
    );
  }

  Widget _confirmForm() {
    return BlocListener<ConfirmBloc, ConfirmState>(
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
            children: [_codeField(), _confirmButton()],
          ),
        ),
      ),
    );
  }

  Widget _codeField() {
    return BlocBuilder<ConfirmBloc, ConfirmState>(builder: (context, state) {
      return TextFormField(
        decoration:
            InputDecoration(icon: Icon(Icons.person), hintText: 'Enter Code'),
        validator: (value) =>
            state.isUserNameValid ? null : "Code not long enough",
        onChanged: (value) => context.read<ConfirmBloc>().add(
              ConfirmCodeChanged(code: value),
            ),
      );
    });
  }

  Widget _confirmButton() {
    return BlocBuilder<ConfirmBloc, ConfirmState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ConfirmBloc>().add(ConfirmSubmitted());
                }
              },
              child: Text('Confirm Code'));
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
