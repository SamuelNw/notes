import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;

  bool _isPasswordHidden = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is EmailAlreadyInUseAuthException) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(
              context,
              "User already exits.",
            );
          } else if (state.exception is WeakPasswordAuthException) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(
              context,
              "User already exits.",
            );
          } else if (state.exception is GenericAuthException) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(
              context,
              "An error occured, try again later.",
            );
          }
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/view_bgs/register_bg.jpg",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      height: 100.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.centerRight,
                      transform: Matrix4.translationValues(-80.0, 0.0, 0.0),
                      child: const Text(
                        "Signup",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60.0),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Transform(
                                transform: Matrix4.translationValues(12.0, -5.0, 0.0),
                                child: const Text(
                                  "First Name",
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              subtitle: TextField(
                                controller: _firstName,
                                keyboardType: TextInputType.name,
                                enableSuggestions: false,
                                autocorrect: false,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "Enter first name",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 20.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Transform(
                                transform: Matrix4.translationValues(12.0, -5.0, 0.0),
                                child: const Text(
                                  "Last Name",
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              subtitle: TextField(
                                controller: _lastName,
                                keyboardType: TextInputType.name,
                                enableSuggestions: false,
                                autocorrect: false,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "Enter last name",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 20.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Transform(
                        transform: Matrix4.translationValues(12.0, 0.0, 0.0),
                        child: const Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 19.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        enableSuggestions: false,
                        autocorrect: false,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: "Enter your Email",
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 20.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                      ),
                      const SizedBox(height: 12.0),
                      Transform(
                        transform: Matrix4.translationValues(12.0, 0.0, 0.0),
                        child: const Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 19.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      TextField(
                        controller: _password,
                        obscureText: _isPasswordHidden,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 20.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          suffixIcon: togglePasswordHidden(),
                        ),
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                25,
                                159,
                                153,
                              ),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(100, 45),
                            ),
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              final firstName = _firstName.text;
                              final lastName = _lastName.text;
                              context.read<AuthBloc>().add(
                                    AuthEventRegister(
                                      email,
                                      password,
                                      firstName,
                                      lastName,
                                    ),
                                  );
                            },
                            child: const Text(
                              "Create Account",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              context.read<AuthBloc>().add(
                                    const AuthEventLogout(),
                                  );
                            },
                            child: const Text(
                              "Login here.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget togglePasswordHidden() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isPasswordHidden = !_isPasswordHidden;
        });
      },
      icon: _isPasswordHidden
          ? const Icon(
              Icons.visibility_outlined,
            )
          : const Icon(
              Icons.visibility_off_outlined,
            ),
      color: const Color.fromARGB(255, 144, 144, 144),
    );
  }
}
