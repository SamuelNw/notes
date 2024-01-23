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
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 6, 41, 37),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_read_rounded,
                color: Color.fromARGB(
                  255,
                  25,
                  159,
                  153,
                ),
                size: 120.0,
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Verify Email",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Check your email for a link to verify your account.",
                style: TextStyle(
                  color: Color.fromARGB(255, 194, 194, 194),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                "If you did not receive the email, click on the button below.",
                style: TextStyle(
                  color: Color.fromARGB(255, 194, 194, 194),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40.0),
              OutlinedButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    const BorderSide(color: Color.fromARGB(255, 14, 65, 72)),
                  ),
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(),
                      );
                },
                child: const Text(
                  "RESEND VERIFICATION EMAIL",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
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
                              "Restart",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey,
                              ),
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
                          child: const Icon(Icons.restart_alt_sharp),
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
    );
  }
}
