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
        backgroundColor: Colors.transparent,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0), // Your navy blue shade
                Color.fromARGB(255, 6, 41, 37), // Your grey shade
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Did you forget your password? \nPlease provide your email address and check it for a password reset link.",
                  style: TextStyle(
                    color: Color.fromARGB(255, 194, 194, 194),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Email",
                    style: TextStyle(
                      color: Color.fromARGB(255, 194, 194, 194),
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Enter your email address",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 154, 154, 154),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 187, 187, 187),
                      ),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 56, 56, 56),
                  ),
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            25,
                            159,
                            153,
                          ),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          final email = _controller.text;
                          context.read<AuthBloc>().add(
                                AuthEventForgotPassword(
                                  email: email,
                                ),
                              );
                        },
                        child: const Text(
                          "RESET PASSWORD",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventLogout(),
                                );
                          },
                          child: const Row(
                            children: [
                              Text(
                                "Back to",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                "Login",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventLogout(),
                                );
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(255, 52, 52, 52),
                                width: 1.0,
                              ),
                            ),
                            child: const Icon(Icons.arrow_back_sharp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
