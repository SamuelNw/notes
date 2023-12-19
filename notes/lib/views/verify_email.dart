import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';

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
      body: Column(
        children: <Widget>[
          const Text(
            "We've sent you a verification email, click on it to verify your account.",
          ),
          const Text(
            "If you did not receive the email, click on the button below.",
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendVerificationEmail();
            },
            child: const Text("Send Verification Email"),
          ),
        ],
      ),
    );
  }
}
