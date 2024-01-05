import "package:notes/services/auth/auth_exceptions.dart";
import "package:notes/services/auth/auth_provider.dart";
import "package:notes/services/auth/auth_user.dart";
import "package:test/test.dart";

void main() {
  group(
    "Mock Authentication:",
    () {
      final provider = MockAuthProvider();

      test(
        "Should not be initialized to begin with",
        () {
          expect(provider.isInitialized, false);
        },
      );

      test(
        "Cannot logout before initialization.",
        () {
          expect(
              provider.logOut(),
              throwsA(
                const TypeMatcher<NotInitializedException>(),
              ));
        },
      );

      test(
        "Should be able to be initialized",
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
      );

      test(
        "User should be null after initialization",
        () {
          expect(provider.currentUser, null);
        },
      );

      test("Should be able to be initialized under 2 seconds", () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      }, timeout: const Timeout(Duration(seconds: 2)));

      /*
      test(
        "Create user should delegate to login function",
        () async {
          final badEmailUser = await provider.createUser(
            email: "foobar@gmail.com",
            password: "foobarbaz",
          );

          expect(
              badEmailUser,
              throwsA(
                const TypeMatcher<InvalidCredentialsAuthException>(),
              ));

          final user = await provider.createUser(
            email: "foo@bar.com",
            password: "barpassword",
          );

          expect(provider.currentUser, user);
          expect(user.isEmailVerified, false);
        },
      );

      test(
        "Logged in user should be able to be verified",
        () {
          provider.sendVerificationEmail();
          final user = provider.currentUser;
          expect(user, isNotNull);
          expect(user!.isEmailVerified, true);
        },
      );

      test("User should be able to logout and login again", () async {
        await provider.logOut();
        await provider.logIn(
          email: "email",
          password: "password",
        );
        final user = provider.currentUser;
        expect(user, isNotNull);
      });
      */
    },
  );
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(
      const Duration(seconds: 1),
    );
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "foobar@gmail.com") throw InvalidCredentialsAuthException();
    const user = AuthUser(id: "my_id", isEmailVerified: false, email: 'foobar@email.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw InvalidCredentialsAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendVerificationEmail() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw InvalidCredentialsAuthException();
    const newUser = AuthUser(id: "my_id", isEmailVerified: true, email: 'foobar@email.com');
    _user = newUser;
  }
}
