import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/helpers/loading/loading_screen.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/services/auth/firebase_auth_provider.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/notes/create_update_note.dart';
import 'package:notes/views/notes/notes_view.dart';
import 'package:notes/views/other/help_and_feedback.dart';
import 'package:notes/views/other/settings.dart';
import 'package:notes/views/password_reset_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/temp_loading_page.dart';
import 'package:notes/views/verify_email.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes/views/landing_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 25, 159, 153),
        ),
        useMaterial3: true,
        fontFamily: "Jost",
      ),
      home: const LandingScreen(),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateOrUpdateNoteView(),
        settingsPageRoute: (context) => const SettingsView(),
        helpAndFeedbackPageRoute: (context) => const HelpAndFeedbackView(),
        homePageRoute: (context) => BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                FirebaseAuthProvider(),
              ),
              child: const HomePage(),
            ),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? "Please wait a moment...",
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const PasswordResetView();
        } else {
          return const TempLoadingPage();
        }
      },
    );
  }
}
