import "package:notes/services/auth/auth_user.dart";

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendVerificationEmail();
  Future<void> sendPasswordReset({required String email});
}
