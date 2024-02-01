import 'package:bloc/bloc.dart';
import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(
          isLoading: true,
        )) {
    // Forgot password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(
        const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ),
      );

      final email = event.email;
      if (email == null) {
        return; // User doesn't really intend to reset password.
      }

      // User actually wants to reset password:
      emit(
        const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: true,
        ),
      );

      Exception? exception;
      bool didSendEmail;

      try {
        await provider.sendPasswordReset(email: email);
        exception = null;
        didSendEmail = true;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(
        AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ),
      );
    });

    // Send Email Verification:
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendVerificationEmail();
      emit(state);
    });

    //Registration:
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      final firstName = event.firstName;
      final lastName = event.lastName;
      try {
        await provider.createUser(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
        );
        await provider.sendVerificationEmail();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });

    on<AuthEventShouldRegister>((event, emit) async {
      emit(const AuthStateRegistering(exception: null, isLoading: false));
    });

    // Initialize:
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      },
    );

    // Login:
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: "Please wait while I log you in.",
          ),
        );
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(email: email, password: password);

          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(const AuthStateNeedsVerification(isLoading: false));
          } else {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );

    // Logout:
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ));
        }
      },
    );
  }
}
