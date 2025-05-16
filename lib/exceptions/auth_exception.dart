class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;

  static String handleFirebaseAuthException(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'network-request-failed':
        return 'No internet connection.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      default:
        return 'An unknown error occurred.';
    }
  }
}
// TODO Implement this library.