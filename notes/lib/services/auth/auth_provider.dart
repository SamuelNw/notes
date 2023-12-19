import "package:notes/services/auth/auth_user.dart";

abstract class AuthProvider {
  AuthProvider.initialize();
  AuthUser? get currentUser;
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendVerificationEmail();
}
