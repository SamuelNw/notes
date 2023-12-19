import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your email"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamed(
                  verifyEmailRoute,
                );
                await AuthService.firebase().sendVerificationEmail();
              } on EmailAlreadyInUseAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(
                  context,
                  "User already exits.",
                );
              } on WeakPasswordAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(
                  context,
                  "Weak Password.",
                );
              } on GenericAuthException {
                if (email.isEmpty || password.isEmpty) {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "Fields cant be empty",
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  await showErrorDialog(
                    context,
                    "An error occured, try again later.",
                  );
                }
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text("Already have an account? Login here."),
          ),
        ],
      ),
    );
  }
}
