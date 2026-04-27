// Failure model
// Represents application errors and failures

/// Application failure model
/// Used to represent errors that occur during API calls or operations
class AppFailure {
  /// The error message describing what went wrong
  final String message;

  /// Creates an AppFailure with the given message
  /// Default message is used if none provided
  const AppFailure({this.message = 'Sorry unexpected error occurred'});

  @override
  String toString() => '''message: sign in error''';
}
