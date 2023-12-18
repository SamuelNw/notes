// login exception:
class InvalidCredentialsAuthException implements Exception {}

// register exceptions:
class EmailAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

// generic exceptions:
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
