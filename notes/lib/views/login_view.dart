import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Column(
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
              final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email,
                password: password,
              );
              print(userCredential);
            } on FirebaseAuthException catch (e) {
              print("Invalid Credentials Provided.");
            } catch (e) {
              print("SOMETHING ELSE HAPPENED!");
            }
          },
          child: const Text("Sign In"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              "/register/",
              (route) => false,
            );
          },
          child: const Text("Not registered yet? Register here."),
        ),
      ],
    );
  }
}
