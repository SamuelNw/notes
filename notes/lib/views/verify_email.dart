import 'package:flutter/material.dart';
import "package:notes/services/auth/bloc/auth_event.dart";
import "package:notes/services/auth/bloc/auth_bloc.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              "We've sent you a verification email, click on it to verify your account.",
            ),
            const Text(
              "If you did not receive the email, click on the button below.",
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventSendEmailVerification(),
                    );
              },
              child: const Text("Send Verification Email"),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogout(),
                    );
              },
              child: const Text("Restart"),
            ),
          ],
        ),
      ),
    );
  }
}
