import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:notes/services/auth/bloc/auth_bloc.dart";
import "package:notes/services/auth/bloc/auth_event.dart";
import "package:notes/services/auth/bloc/auth_state.dart";
import "package:notes/utilities/dialogs/error_dialog.dart";
import "package:notes/utilities/dialogs/password_reset_email_sent.dart";

class PasswordResetView extends StatefulWidget {
  const PasswordResetView({super.key});

  @override
  State<PasswordResetView> createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateForgotPassword) {
            if (state.hasSentEmail) {
              _controller.clear();
              await showPasswordResetDialoog(context);
            }
            if (state.exception != null) {
              // ignore: use_build_context_synchronously
              await showErrorDialog(
                context,
                "We could not process your request. The email you provided is not registered to any account. Check and provide an already registered email account.",
              );
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Forgot Password"),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Text(
                  "Did you forget your password? Please provide your email address and check it for a password reset link.",
                ),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Enter your email address",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final email = _controller.text;
                    context.read<AuthBloc>().add(
                          AuthEventForgotPassword(
                            email: email,
                          ),
                        );
                  },
                  child: const Text(
                    "Send me the verification email",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  },
                  child: const Text(
                    "Back to Login",
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
