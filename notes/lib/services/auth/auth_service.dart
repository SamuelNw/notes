import "package:notes/services/auth/auth_user.dart";
import "package:notes/services/auth/firebase_auth_provider.dart";
import "package:notes/services/auth/auth_provider.dart";

class AuthService implements FirebaseAuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) =>
      provider.createUser(
        email: email,
        password: password,
        firstName: '',
        lastName: '',
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendVerificationEmail() => provider.sendVerificationEmail();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> sendPasswordReset({required String email}) => provider.sendPasswordReset(
        email: email,
      );
}
